import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../model/memory_model/memory_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('memories.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _migrateDatabase,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        location TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        isDeleted INTEGER NOT NULL DEFAULT 0,
        mediaFiles TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  // Migration for existing databases
  Future<void> _migrateDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add isDeleted column if it doesn't exist
      try {
        await db.execute('ALTER TABLE memories ADD COLUMN isDeleted INTEGER NOT NULL DEFAULT 0');
      } catch (e) {
        // Column might already exist
        print('Migration note: $e');
      }
    }
  }

  // Create memory
  Future<Memory> createMemory(Memory memory) async {
    final db = await database;
    final json = memory.toJson();
    // Ensure createdAt exists
    if (!json.containsKey('createdAt')) {
      json['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    }
    final id = await db.insert(
      'memories',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return memory.copyWith(id: id);
  }

  // Create memory with json (for backward compatibility)
  Future<Memory> createMemoryFromJson(Map<String, dynamic> json) async {
    final db = await database;
    if (!json.containsKey('createdAt')) {
      json['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    }
    final id = await db.insert(
      'memories',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    json['id'] = id;
    return Memory.fromJson(json);
  }

  // Read all memories (excluding deleted)
  Future<List<Memory>> getAllMemories() async {
    final db = await database;
    final result = await db.query(
      'memories',
      where: 'isDeleted = ?',
      whereArgs: [0],
      orderBy: 'date DESC, createdAt DESC',
    );

    return result.map((json) => Memory.fromJson(json)).toList();
  }

  // Read all memories including deleted (for admin)
  Future<List<Memory>> getAllMemoriesIncludingDeleted() async {
    final db = await database;
    final result = await db.query(
      'memories',
      orderBy: 'date DESC, createdAt DESC',
    );

    return result.map((json) => Memory.fromJson(json)).toList();
  }

  // Read deleted memories only
  Future<List<Memory>> getDeletedMemories() async {
    final db = await database;
    final result = await db.query(
      'memories',
      where: 'isDeleted = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );

    return result.map((json) => Memory.fromJson(json)).toList();
  }

  // Read single memory
  Future<Memory?> getMemory(int id) async {
    final db = await database;
    final result = await db.query(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Memory.fromJson(result.first);
    }
    return null;
  }

  // Update memory
  Future<int> updateMemory(Memory memory) async {
    final db = await database;
    return await db.update(
      'memories',
      memory.toJson(),
      where: 'id = ?',
      whereArgs: [memory.id],
    );
  }

  // Soft delete memory (mark as deleted)
  Future<int> deleteMemory(int id) async {
    final db = await database;
    return await db.update(
      'memories',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Permanently delete memory (admin only)
  Future<int> permanentDeleteMemory(int id) async {
    final db = await database;
    return await db.delete(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Restore deleted memory
  Future<int> restoreMemory(int id) async {
    final db = await database;
    return await db.update(
      'memories',
      {'isDeleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get favorite memories
  Future<List<Memory>> getFavoriteMemories() async {
    final db = await database;
    final result = await db.query(
      'memories',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );

    return result.map((json) => Memory.fromJson(json)).toList();
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
