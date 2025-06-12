class Faculty {
  final String id;
  final String collegeId;
  final String facultyName;
  final String designation;
  final String contactNumber;

  Faculty({
    required this.id,
    required this.collegeId,
    required this.facultyName,
    required this.designation,
    required this.contactNumber,
  });

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      facultyName: map['facultyName'] ?? '',
      designation: map['designation'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'collegeId': collegeId,
      'facultyName': facultyName,
      'designation': designation,
      'contactNumber': contactNumber,
    };
  }
}
