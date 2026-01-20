import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'database/database_service.dart';

class DatabaseAdmin {
  static final DatabaseService _db = DatabaseService.instance;

  /// Get the database file path
  static Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return '$dbPath/memories.db';
  }

  /// Get database file information
  static Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await _db.database;
      final path = await getDatabasePath();
      final file = File(path);
      
      return {
        'path': path,
        'exists': await file.exists(),
        'size': await file.exists() ? await file.length() : 0,
        'version': await db.getVersion(),
        'isOpen': db.isOpen,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Get table information
  static Future<List<Map<String, dynamic>>> getTableInfo() async {
    try {
      final db = await _db.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      
      List<Map<String, dynamic>> tableInfo = [];
      
      for (var table in tables) {
        final tableName = table['name'] as String;
        if (tableName == 'sqlite_sequence') continue;
        
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
        ) ?? 0;
        
        final schema = await db.rawQuery(
          "PRAGMA table_info($tableName)",
        );
        
        tableInfo.add({
          'name': tableName,
          'count': count,
          'columns': schema,
        });
      }
      
      return tableInfo;
    } catch (e) {
      return [{'error': e.toString()}];
    }
  }

  /// Execute raw SQL query (admin only)
  static Future<List<Map<String, dynamic>>> executeRawQuery(String query) async {
    try {
      final db = await _db.database;
      return await db.rawQuery(query);
    } catch (e) {
      Get.snackbar('Database Error', e.toString());
      return [{'error': e.toString()}];
    }
  }

  /// Get all memories as raw data (including deleted)
  static Future<List<Map<String, dynamic>>> getAllMemoriesRaw() async {
    try {
      final db = await _db.database;
      return await db.query('memories', orderBy: 'date DESC, createdAt DESC');
    } catch (e) {
      return [{'error': e.toString()}];
    }
  }

  /// Get deleted memories as raw data
  static Future<List<Map<String, dynamic>>> getDeletedMemoriesRaw() async {
    try {
      final db = await _db.database;
      return await db.query(
        'memories',
        where: 'isDeleted = ?',
        whereArgs: [1],
        orderBy: 'createdAt DESC',
      );
    } catch (e) {
      return [{'error': e.toString()}];
    }
  }

  /// Export database to JSON
  static Future<Map<String, dynamic>> exportDatabase() async {
    try {
      final memories = await _db.getAllMemories();
      final info = await getDatabaseInfo();
      final tableInfo = await getTableInfo();
      
      return {
        'exportDate': DateTime.now().toIso8601String(),
        'databaseInfo': info,
        'tables': tableInfo,
        'memories': memories.map((m) => m.toJson()).toList(),
        'totalMemories': memories.length,
        'favoriteMemories': memories.where((m) => m.isFavorite).length,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Clear all memories (admin action)
  static Future<bool> clearAllMemories() async {
    try {
      final db = await _db.database;
      await db.delete('memories');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear memories: $e');
      return false;
    }
  }

  /// Print database statistics to console
  static Future<void> printDatabaseStats() async {
    try {
      final info = await getDatabaseInfo();
      final tableInfo = await getTableInfo();
      final memories = await _db.getAllMemories();
      
      print('═══════════════════════════════════════');
      print('📊 DATABASE ADMIN STATISTICS');
      print('═══════════════════════════════════════');
      print('📍 Path: ${info['path']}');
      print('📦 Size: ${(info['size'] as int) / 1024} KB');
      print('🔢 Version: ${info['version']}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📋 TABLES:');
      for (var table in tableInfo) {
        print('  • ${table['name']}: ${table['count']} records');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('💕 MEMORIES STATS:');
      print('  • Total: ${memories.length}');
      print('  • Favorites: ${memories.where((m) => m.isFavorite).length}');
      print('  • With Media: ${memories.where((m) => m.mediaFiles.isNotEmpty).length}');
      print('═══════════════════════════════════════');
    } catch (e) {
      print('Error printing stats: $e');
    }
  }

  /// Get database path for manual access
  static Future<void> showDatabasePath() async {
    final path = await getDatabasePath();
    Get.dialog(
      AlertDialog(
        title: Text('Database Location'),
        content: SelectableText(path),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
