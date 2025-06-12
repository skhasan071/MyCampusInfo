import 'dart:convert';
import 'package:my_campus_info/model/user.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl = 'https://tc-ca-server.onrender.com/api/students/student';

  // 🔹 Register Student
  static Future<Map<String, dynamic>> registerStudent(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data['message'],
          "token": data['token'],
          "student": Student.fromMap(data['data']),
        };
      } else {

        final data = jsonDecode(response.body);
        return {"success": false, "message": formatErrorMessage(data['error']['details'][0]['message'])};

      }
    } catch (e) {

      print(e);
      return {"success": false, "message": e.toString()};

    }
  }

  // 🔹 Login Student
  static Future<Map<String, dynamic>> loginStudent(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          "success": true,
          "message": data['message'],
          "token": data['token'],
          "student": Student.fromMap(data['data']),
        };
      } else {
        final data = jsonDecode(response.body);
        return {"success": false, "message": formatErrorMessage(data['message'])};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> loginViaGoogle(String tokenId) async{

    final url = Uri.parse('$baseUrl/google/login');

    try{

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "tokenId": tokenId,
        }),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return {
          'firstTime': data['firstTime'],
          "success": true,
          "message": data['message'],
          "token": data['token'],
          "student": Student.fromMap(data['data']),
        };

      } else {
        final data = jsonDecode(response.body);
        return {"success": false, "message": formatErrorMessage(data['message'])};
      }

    }catch(e){
      return {"success": false, "message": e.toString()};
    }

  }

  static Future<Map<String, dynamic>> sendOtp(String email) async {
    final url = Uri.parse('https://tc-ca-server.onrender.com/api/students/forgot-password/send-otp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": data['message']};
      } else {
        return {"success": false, "message": data['message']};
      }

    } catch (e) {
      print(e);
      return {"success": false, "message": e.toString()};
    }
  }

  // 🔹 Verify OTP and reset password
  static Future<Map<String, dynamic>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('https://tc-ca-server.onrender.com/api/students/forgot-password/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "newPassword": newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": data['message']};
      } else {
        return {"success": false, "message": data['message']};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static String formatErrorMessage(String message) {
    // Remove quotes around the field name
    message = message.replaceAll('"', '');

    // Capitalize the first word (field name)
    List<String> words = message.split(' ');
    if (words.isNotEmpty) {
      words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    }

    // Capitalize the last word if it matches the field name
    if (words.isNotEmpty && words.last.toLowerCase() == words[0].toLowerCase()) {
      words[words.length - 1] = words.last[0].toUpperCase() + words.last.substring(1);
    }

    return words.join(' ');
  }

}