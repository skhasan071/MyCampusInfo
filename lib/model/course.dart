class Course {
  final String id;
  final String collegeId;
  final String courseName;
  final String duration;
  final double fees;
  final String examType;
  final String category;
  final String rankType; // "Rank" or "Percentile"
  final double maxRankOrPercentile;

  Course({
    required this.id,
    required this.collegeId,
    required this.courseName,
    required this.duration,
    required this.fees,
    required this.examType,
    required this.category,
    required this.rankType,
    required this.maxRankOrPercentile,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      courseName: map['courseName'] ?? '',
      duration: map['duration'] ?? '',
      fees: (map['fees'] ?? 0).toDouble(),
      examType: map['examType'] ?? '',
      category: map['category'] ?? '',
      rankType: map['rankType'] ?? '',
      maxRankOrPercentile: (map['maxRankOrPercentile'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'collegeId': collegeId,
      'courseName': courseName,
      'duration': duration,
      'fees': fees,
      'examType': examType,
      'category': category,
      'rankType': rankType,
      'maxRankOrPercentile': maxRankOrPercentile,
    };
  }
}
