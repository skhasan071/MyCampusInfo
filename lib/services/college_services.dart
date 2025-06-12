import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Faculty.dart';
import '../model/Hostel.dart';
import '../model/admission_process.dart';
import '../model/campus.dart';
import '../model/college.dart';
import '../model/course.dart';

class CollegeServices {

  static const String _baseUrl = 'https://tc-ca-server.onrender.com/api/colleges/';

  /// Get all colleges
  static Future<List<College>> getColleges() async {
    final url = Uri.parse('${_baseUrl}all');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => College.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<College>> searchColleges({required String searchText, List<String>? streams, List<String>? states, List<String>? cities,}) async {
    final uri = Uri.https('tc-ca-server.onrender.com', '/api/colleges/search', {
      'search': searchText,
      if (streams != null && streams.isNotEmpty) 'stream': streams.join(','),
      if (states != null && states.isNotEmpty) 'state': states.join(','),
      if (cities != null && cities.isNotEmpty) 'cities': cities.join(','),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List colleges = json.decode(response.body);
        return colleges.map((item) => College.fromMap(item)).toList();
      } else {
        final error = json.decode(response.body);
        return [error];
      }
    } catch (e) {
      return [];
    }
  }

  ///Get Filters
  static Future<List<College>> filterColleges({required List<String> interestedStreams, List<String>? coursesInterested, String? type,}) async {
    final url = Uri.parse('${_baseUrl}filter');

    try {
      final response = await http.post(
        url,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          'interestedStreams': interestedStreams,
          'coursesInterested': coursesInterested,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['colleges'];
        return jsonData.map((e) => College.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {

      return [];
    }
  }

  static Future<List<College>> filterCollegesByRanking({required String stream, String? ranking,}) async {
    final uri = Uri.parse('${_baseUrl}colleges/filter-by-ranking')
        .replace(queryParameters: {
      'stream': stream,
      if (ranking != null) 'ranking': ranking,
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((college) => College.fromMap(college)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<College>> fetchFilteredColleges({required List<String> streams, String? country, String? state, String? city,}) async {
    final baseUrl = Uri.parse('${_baseUrl}filter-by-stream');

    // Create query parameters
    final queryParams = {
      'stream': streams,
      if (country != null) 'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
    };

    final uri = Uri(
      scheme: baseUrl.scheme,
      host: baseUrl.host,
      port: baseUrl.port,
      path: baseUrl.path,
      queryParameters: {
        'stream': streams,
        if (country != null) 'country': [country],
        if (state != null) 'state': [state],
        if (city != null) 'city': [city],
      },
    );


    final response = await http.get(uri);

    if (response.statusCode == 200) {

      var json = jsonDecode(response.body);

      if (json is List) {
        return json.map((d) => College.fromMap(d)).toList();
      } else if (json is Map && json['message'] != null) {
        return [json['message']];
      } else {
        return [];
      }

    } else {
      return [];
    }
  }

  static Future<List<College>> predictColleges({
    required String examType,
    required String category,
    required String rankType,
    required dynamic rankOrPercentile,
    required String state,
  }) async {
    final uri = Uri.parse('${_baseUrl}predict');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'examType': examType,
          'category': category,
          'rankType': rankType,
          'rankOrPercentile': rankOrPercentile,
          'state': state,
        }),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => College.fromMap(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get College Details Page
  static Future<AdmissionProcess?> getAdmissionProcess(String collegeId) async {
    final url = Uri.parse('$_baseUrl$collegeId/admission-process');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AdmissionProcess.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Course>> getCoursesByCollege(String collegeId) async {
    final url = Uri.parse('${_baseUrl}courses/$collegeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => Course.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Faculty>> getFacultyByCollege(String collegeId) async {
    final url = Uri.parse('${_baseUrl}faculty/$collegeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => Faculty.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Hostel?> getHostelByCollege(String collegeId) async {
    final url = Uri.parse('${_baseUrl}hostel/$collegeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Hostel.fromMap(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Campus?> getCampusByCollege(String collegeId) async {
    final url = Uri.parse('${_baseUrl}campus/$collegeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Campus.fromMap(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<Map<String, dynamic>> getScholarshipsByCollege(String collegeId) async {
    final response = await http.get(
      Uri.parse('https://tc-ca-server.onrender.com/api/scholarships/$collegeId'), // Modify with your API URL
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Assuming response contains scholarships data
    } else {
      throw Exception('Failed to load scholarships');
    }
  }
}
