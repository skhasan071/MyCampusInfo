class Campus {
  final String id;
  final String collegeId;
  final List<String> amenities;
  final List<String> photos;
  final List<String> videos;

  Campus({
    required this.id,
    required this.collegeId,
    required this.amenities,
    required this.photos,
    required this.videos,
  });

  factory Campus.fromMap(Map<String, dynamic> map) {
    return Campus(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      videos: List<String>.from(map['videos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'collegeId': collegeId,
      'amenities': amenities,
      'photos': photos,
      'videos': videos,
    };
  }
}
