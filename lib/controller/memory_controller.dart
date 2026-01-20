import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaaram/controller/utils/database/database_service.dart';
import '../model/memory_model/memory_model.dart';
import '../model/media_file_model/media_file_model.dart';

class MemoryController extends GetxController {
  final RxList<Memory> memories = <Memory>[].obs;
  final RxBool isLoading = false.obs;
  final DatabaseService _db = DatabaseService.instance;

  @override
  void onInit() {
    super.onInit();
    loadMemories();
  }

  // Load memories from SQLite database
  Future<void> loadMemories() async {
    try {
      isLoading.value = true;
      final loadedMemories = await _db.getAllMemories();
      
      memories.value = loadedMemories;

      // If no memories exist, load default ones
      if (memories.isEmpty) {
        await _loadDefaultMemories();
      }
    } catch (e) {
      print('Error loading memories: $e');
      Get.snackbar(
        'Error',
        'Failed to load memories: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Copy media files to app directory for persistence
  Future<String> _copyMediaToAppDirectory(String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${appDir.path}/memories_media');
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final fileName = sourcePath.split('/').last;
      final destPath = '${mediaDir.path}/$fileName';
      await File(sourcePath).copy(destPath);
      return destPath;
    } catch (e) {
      print('Error copying media: $e');
      return sourcePath; // Return original path if copy fails
    }
  }

  // Add a new memory and return the created memory
  Future<Memory?> addMemory(Memory memory) async {
    try {
      // Copy media files to app directory
      final copiedMediaFiles = <MediaFile>[];
      for (var media in memory.mediaFiles) {
        final newPath = await _copyMediaToAppDirectory(media.path);
        copiedMediaFiles.add(MediaFile(
          path: newPath,
          type: media.type,
          thumbnailPath: media.thumbnailPath,
        ));
      }

      final memoryWithCopiedMedia = memory.copyWith(mediaFiles: copiedMediaFiles);
      final newId = DateTime.now().millisecondsSinceEpoch;
      final json = memoryWithCopiedMedia.copyWith(id: newId).toJson();
      json['createdAt'] = DateTime.now().millisecondsSinceEpoch;
      final createdMemory = await _db.createMemoryFromJson(json);
      
      await loadMemories();
      
      // Find the created memory in the list
      final savedMemory = memories.firstWhereOrNull((m) => m.id == createdMemory.id);
      
      Get.snackbar(
        'Success',
        '💕 Memory saved to our love story',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      return savedMemory;
    } catch (e) {
      print('Error adding memory: $e');
      Get.snackbar(
        'Error',
        'Failed to save memory: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Update a memory
  Future<void> updateMemory(Memory updatedMemory) async {
    try {
      await _db.updateMemory(updatedMemory);
      await loadMemories();
    } catch (e) {
      print('Error updating memory: $e');
      Get.snackbar(
        'Error',
        'Failed to update memory',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete a memory
  Future<void> deleteMemory(int id) async {
    try {
      await _db.deleteMemory(id);
      await loadMemories();
      Get.snackbar(
        'Deleted',
        'Memory removed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting memory: $e');
      Get.snackbar(
        'Error',
        'Failed to delete memory',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int id) async {
    try {
      final index = memories.indexWhere((m) => m.id == id);
      if (index != -1) {
        final memory = memories[index];
        final updatedMemory = memory.copyWith(isFavorite: !memory.isFavorite);
        await _db.updateMemory(updatedMemory);
        await loadMemories();
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Get favorite memories
  List<Memory> get favoriteMemories {
    return memories.where((m) => m.isFavorite).toList();
  }

  // Get days together
  int get daysTogether {
    if (memories.isEmpty) return 0;
    final firstDate = memories.last.date;
    return DateTime.now().difference(firstDate).inDays;
  }

  // Load default memories
  Future<void> _loadDefaultMemories() async {
    final defaultMemories = [
      Memory(
        id: DateTime(2024, 1, 14).millisecondsSinceEpoch,
        date: DateTime(2024, 1, 14),
        title: 'Our First Date',
        description:
            'The day everything changed. Coffee turned into hours of conversation, and I knew you were special.',
        location: 'Café Moments',
        isFavorite: true,
        isDeleted: false,
        mediaFiles: [],
      ),
      Memory(
        id: DateTime(2024, 2, 14).millisecondsSinceEpoch,
        date: DateTime(2024, 2, 14),
        title: 'Valentine\'s Day Magic',
        description:
            'You looked stunning in that red dress. The way you smiled when I gave you those roses... unforgettable.',
        location: 'Riverside Restaurant',
        isFavorite: false,
        isDeleted: false,
        mediaFiles: [],
      ),
      Memory(
        id: DateTime(2024, 3, 20).millisecondsSinceEpoch,
        date: DateTime(2024, 3, 20),
        title: 'Sunset at the Beach',
        description:
            'Walking hand in hand, the waves at our feet. You laughed so freely, and my heart was completely yours.',
        location: 'Paradise Beach',
        isFavorite: true,
        isDeleted: false,
        mediaFiles: [],
      ),
      Memory(
        id: DateTime(2024, 5, 10).millisecondsSinceEpoch,
        date: DateTime(2024, 5, 10),
        title: 'Movie Night Cuddles',
        description:
            'We didn\'t even finish the movie. Just being close to you was all the entertainment I needed.',
        location: 'Home Sweet Home',
        isFavorite: false,
        isDeleted: false,
        mediaFiles: [],
      ),
    ];

    for (var memory in defaultMemories) {
      final json = memory.toJson();
      json['createdAt'] = memory.date.millisecondsSinceEpoch;
      await _db.createMemory(Memory.fromJson(json));
    }
    
    await loadMemories();
  }

  @override
  void onClose() {
    _db.close();
    super.onClose();
  }
}