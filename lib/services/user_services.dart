import 'dart:convert';
import 'dart:io';
import 'package:my_campus_info/model/user.dart';
import 'package:http/http.dart' as http;

import '../model/college.dart';
import '../model/review.dart';

class StudentService {
  static const String _baseUrl =
      'http://3.7.169.233/api2/students';

  Future<Student?> fetchStudentById(String id) async {
    final url = Uri.parse(
      '$_baseUrl/get/$id',
    ); // Update with your actual backend URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Student.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Student?> getStudent(token) async {
    try {
      final res = await http.get(
        Uri.parse("$_baseUrl/verify-user/$token"),
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> data =
            jsonDecode(res.body) as Map<String, dynamic>;

        return Student.fromMap(data);
      } else {
        return null;
      }
    } catch (err) {
      return null;
    }
  }

  /// Add or update student profile
  static Future<Student?> addOrUpdateStudent({
    required String token,
    required String mobileNumber,
    required String name,
    required String email,
    required String studyingIn,
    required String city,
    required String state,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/add'); // Replace with actual URL

    var request = http.MultipartRequest('POST', uri);

    print('<-------------------------------->' + token);
    // Set headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add fields
    request.fields['mobileNumber'] = mobileNumber;
    request.fields['studyingIn'] = studyingIn;
    request.fields['city'] = city;
    request.fields['state'] = state;
    request.fields['name'] = name;
    request.fields['email'] = email;

    // Add image file (if provided)
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(responseBody);
        return Student.fromMap(data);
      } else {
        print("Server responded: $responseBody");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<Map<String, dynamic>?> saveCoursePreferences({
    required String token,
    List<String>? interestedStreams,
    List<String>? coursesInterested,
    String? preferredYearOfAdmission,
    String? preferredCourseLevel,
    String? modeOfStudy,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/preferences');
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (interestedStreams != null) 'interestedStreams': interestedStreams,
          if (coursesInterested != null) 'coursesInterested': coursesInterested,
          if (preferredYearOfAdmission != null)
            'preferredYearOfAdmission': preferredYearOfAdmission,
          if (preferredCourseLevel != null)
            'preferredCourseLevel': preferredCourseLevel,
          if (modeOfStudy != null) 'modeOfStudy': modeOfStudy,
        }),
      );

      print((jsonDecode(response.body)));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> addToFavorites({
    required String studentId,
    required String collegeId,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/favorites/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'studentId': studentId, 'collegeId': collegeId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // { message, favorites }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<College>> getFavoriteColleges(
    String studentId, [
    void setState,
  ]) async {
    try {
      final uri = Uri.parse('$_baseUrl/favorites/$studentId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final favoritesList = data['favorites'] as List<dynamic>;

        // Convert each favorite map to a Student object
        final students =
            favoritesList.map((item) => College.fromMap(item)).toList();

        return students; // This should be a list of college objects
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> removeFromFavorites(
    String studentId,
    String collegeId,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/favorites/remove');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"studentId": studentId, "collegeId": collegeId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Review?> postReview(Review review) async {
    final url = Uri.parse(
      'http://3.7.169.233:8080/api2/colleges/reviews',
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(review.toJson()),
      );

      if (response.statusCode == 201) {
        return Review.fromJson(jsonDecode(response.body)['review']);
      } else {
        return null;
      }
    } catch (err) {
      return null;
    }
  }

  Future<List<Review>> getReviews(String uid) async {
    final url = Uri.parse(
      'http://3.7.169.233:8080/api2/colleges/reviews/getAll/$uid',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((json) => Review.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  ///Filters
  static Future<List<College>> getCollegesByRanking(String studentId) async {
    try {
      final uri = Uri.parse('$_baseUrl/rankings?studentId=$studentId');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> list = data['colleges'];
        return list.map((item) {
          return College.fromMap(item);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<College>> getPrivateCollegesByInterest(
    String studentId,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/private-colleges');

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"studentId": studentId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final favoritesList = data['colleges'] as List<dynamic>;

        // Convert each favorite map to a Student object
        final students =
            favoritesList.map((item) => College.fromMap(item)).toList();

        return students; // This should be a list of college objects
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
