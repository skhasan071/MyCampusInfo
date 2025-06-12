import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../view_model/profile_controller.dart';

class OtpService {
  final String baseUrl = 'https://tc-ca-server.onrender.com';
  final pfpController = Get.put(ProfileController());

  /// Send OTP to the given phone number
  Future<bool> sendOtp(String phone) async {
    final url = Uri.parse('$baseUrl/api/students/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return true;
      } else {
        print(data);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Verify the OTP for the given phone number
  Future<bool> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$baseUrl/api/students/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        print(data['data']);
        print(data['token']);
        saveToken(data['token']);
        pfpController.userToken.value = data['token'];
        pfpController.profile.value = Student(id: data['data']['_id'], mobileNumber: phone);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

}
