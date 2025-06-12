import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../view/SignUpLogin/login.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({super.key, required this.email});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool loading = false;

  void _verifyAndResetPassword() async {
    final otp = otpController.text.trim();
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if ([otp, newPassword, confirmPassword].any((field) => field.isEmpty)) {
      _showSnackbar("Please fill in all fields", Colors.black);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackbar("Passwords do not match", Colors.black);
      return;
    }

    setState(() => loading = true);
    final result = await AuthService.verifyOtpAndResetPassword(
      email: widget.email,
      otp: otp,
      newPassword: newPassword,
    );
    setState(() => loading = false);

    if (result['success']) {
      _showSnackbar("Password reset successfully", Colors.black);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      });
    } else {
      _showSnackbar(result['message'], Colors.black);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify OTP", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(otpController, "Enter OTP", Icons.numbers),
                const SizedBox(height: 15),
                _buildPasswordField(
                  passwordController,
                  "New Password",
                  isPasswordVisible,
                  () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
                const SizedBox(height: 15),
                _buildPasswordField(
                  confirmPasswordController,
                  "Confirm Password",
                  isConfirmPasswordVisible,
                  () {
                    setState(
                      () =>
                          isConfirmPasswordVisible = !isConfirmPasswordVisible,
                    );
                  },
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
                    onPressed: loading ? null : _verifyAndResetPassword,
                    child:
                        loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool isVisible,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
