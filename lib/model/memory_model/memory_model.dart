import 'dart:convert';
import '../media_file_model/media_file_model.dart';

class Memory {
  final int id;
  final DateTime date;
  final String title;
  final String description;
  final String location;
  final bool isFavorite;
  final bool isDeleted;
  final List<MediaFile> mediaFiles;

  Memory({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.location,
    required this.isFavorite,
    this.isDeleted = false,
    this.mediaFiles = const [],
  });

  // Backward compatibility: get first image path
  String? get imagePath => mediaFiles.isNotEmpty && mediaFiles.first.isImage
      ? mediaFiles.first.path
      : null;

  // Get all images
  List<MediaFile> get images => mediaFiles.where((m) => m.isImage).toList();

  // Get all videos
  List<MediaFile> get videos => mediaFiles.where((m) => m.isVideo).toList();

  // Convert Memory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'location': location,
      'isFavorite': isFavorite ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'mediaFiles': jsonEncode(mediaFiles.map((m) => m.toJson()).toList()),
    };
  }

  // Create Memory from JSON
  factory Memory.fromJson(Map<String, dynamic> json) {
    List<MediaFile> media = [];
    if (json['mediaFiles'] != null) {
      try {
        final mediaJson = jsonDecode(json['mediaFiles'] as String) as List;
        media = mediaJson.map((m) => MediaFile.fromJson(m)).toList();
      } catch (e) {
        // Fallback for old format
        if (json['imagePath'] != null) {
          media = [
            MediaFile(
              path: json['imagePath'] as String,
              type: MediaType.image,
            )
          ];
        }
      }
    } else if (json['imagePath'] != null) {
      // Backward compatibility
      media = [
        MediaFile(
          path: json['imagePath'] as String,
          type: MediaType.image,
        )
      ];
    }

    return Memory(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      isFavorite: (json['isFavorite'] is int)
          ? (json['isFavorite'] as int) == 1
          : (json['isFavorite'] as bool),
      isDeleted: (json['isDeleted'] is int)
          ? (json['isDeleted'] as int) == 1
          : (json['isDeleted'] as bool? ?? false),
      mediaFiles: media,
    );
  }

  // Create a copy with updated fields
  Memory copyWith({
    int? id,
    DateTime? date,
    String? title,
    String? description,
    String? location,
    bool? isFavorite,
    bool? isDeleted,
    List<MediaFile>? mediaFiles,
  }) {
    return Memory(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      mediaFiles: mediaFiles ?? this.mediaFiles,
    );
  }
}