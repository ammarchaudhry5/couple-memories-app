enum MediaType { image, video }

class MediaFile {
  final String path;
  final MediaType type;
  final String? thumbnailPath;

  MediaFile({
    required this.path,
    required this.type,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toString().split('.').last,
      'thumbnailPath': thumbnailPath,
    };
  }

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      path: json['path'] as String,
      type: MediaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MediaType.image,
      ),
      thumbnailPath: json['thumbnailPath'] as String?,
    );
  }

  bool get isImage => type == MediaType.image;
  bool get isVideo => type == MediaType.video;
}
