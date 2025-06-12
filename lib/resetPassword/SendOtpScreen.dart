import 'package:my_campus_info/resetPassword/verify.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  _SendOtpPageState createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpScreen> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;

  void _sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar("Please enter your email", Colors.black);
      return;
    }

    setState(() => loading = true);
    final result = await AuthService.sendOtp(email);
    if (mounted) {
      setState(() => loading = false);
    }

    if (result['success']) {
      _showSnackbar("OTP sent successfully", Colors.black);
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpPage(email: email)),
        );
      });
    } else {
      _showSnackbar(result['message'], Colors.black);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your registered email to receive OTP.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: loading ? null : _sendOtp,
                  child:
                      loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Send OTP",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
