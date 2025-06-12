class Student {
  String id;
  String? name;
  String? email;
  String? password;
  final String? mobileNumber;
  final String? dob;
  final String? gender;
  final String? studyingIn;
  final String? city;
  final String? state;
  final String? image;
  List<String>? interestedStreams;
  List<String>? coursesInterested;
  String? preferredCourseLevel;
  String? modeOfStudy;
  String? preferredYearOfAdmission;
  final List<String>? favorites;

  Student({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.mobileNumber,
    this.dob,
    this.gender,
    this.studyingIn,
    this.city,
    this.state,
    this.image,
    this.interestedStreams,
    this.coursesInterested,
    this.preferredCourseLevel,
    this.modeOfStudy,
    this.preferredYearOfAdmission,
    this.favorites,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      mobileNumber: map['mobileNumber'],
      dob: map['dob'],
      gender: map['gender'],
      studyingIn: map['studyingIn'],
      city: map['city'],
      state: map['state'],
      image: map['image'],
      interestedStreams: map['interestedStreams'] != null
          ? List<String>.from(map['interestedStreams'])
          : null,
      coursesInterested: map['coursesInterested'] != null
          ? List<String>.from(map['coursesInterested'])
          : null,
      preferredCourseLevel: map['preferredCourseLevel'],
      modeOfStudy: map['modeOfStudy'],
      preferredYearOfAdmission: map['preferredYearOfAdmission'],
      favorites: map['favorites'] != null
          ? List<String>.from(map['favorites'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'gender': gender,
      'studyingIn': studyingIn,
      'city': city,
      'state': state,
      'image': image,
      'interestedStreams': interestedStreams,
      'coursesInterested': coursesInterested,
      'preferredCourseLevel': preferredCourseLevel,
      'modeOfStudy': modeOfStudy,
      'preferredYearOfAdmission': preferredYearOfAdmission,
      'favorites': favorites,
    };
  }
}
