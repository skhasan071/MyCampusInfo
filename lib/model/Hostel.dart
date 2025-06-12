class Hostel {
  final String id;
  final String collegeId;
  final String hostelName;
  final List<String> hostelAmenities;
  final String hostelInfo;
  final List<String> campusAmenities;
  final List<String> photos;
  final List<String> videos;

  Hostel({
    required this.id,
    required this.collegeId,
    required this.hostelName,
    required this.hostelAmenities,
    required this.campusAmenities,
    required this.hostelInfo,
    required this.photos,
    required this.videos,
  });

  factory Hostel.fromMap(Map<String, dynamic> map) {
    return Hostel(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      hostelName: map['hostelName'] ?? '',
      hostelAmenities: List<String>.from(map['hostelAmenities'] ?? []),
      campusAmenities: List<String>.from(map['campusAmenities'] ?? []),
      hostelInfo: map['hostelInfo']?.toInt() ?? 0,
      photos: List<String>.from(map['photos'] ?? []),
      videos: List<String>.from(map['videos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'collegeId': collegeId,
      'hostelName': hostelName,
      'hostelAmenities': hostelAmenities,
      'campusAmenities':campusAmenities,
      'hostelInfo': hostelInfo,
      'photos': photos,
      'videos': videos,
    };
  }
}
