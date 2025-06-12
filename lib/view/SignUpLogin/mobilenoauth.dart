import 'package:flutter/material.dart';
import '../../services/otp_service.dart';
import 'otpscreen.dart';

class Mobilenoauth extends StatefulWidget {
  const Mobilenoauth({super.key});

  @override
  _MobilenoauthState createState() => _MobilenoauthState();
}

class _MobilenoauthState extends State<Mobilenoauth> {
  final TextEditingController phoneController = TextEditingController();
  final OtpService otpService =
      OtpService(); // baseUrl is set in the service file

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> handleContinue() async {
    String phone = '+91${phoneController.text.trim()}';

    if (phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 10-digit mobile number")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await otpService.sendOtp(phone);

    setState(() => isLoading = false);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phone: phone)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/otp_image.png', height: 150),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    "Login with a Mobile Number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your mobile number. We will send you an OTP to verify.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      "+91",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter mobile number",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Continue",
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
