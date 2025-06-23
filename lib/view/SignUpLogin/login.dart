import 'package:my_campus_info/services/auth_services.dart';
import 'package:my_campus_info/view/SignUpLogin/signuppage.dart';
import 'package:my_campus_info/view/profiles/complete_profile_page.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resetPassword/SendOtpScreen.dart';
import '../../view_model/controller.dart';
import '../../view_model/data_loader.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void dispose() {
    super.dispose();
  }

  var loader = Get.put(Loader());

  bool isPasswordVisible = false;

  Future<void> _handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegex.hasMatch(email)){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid Email"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      loader.isLoading(false);

    } else if(!passwordRegex.hasMatch(password)){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 8 characters long,and a mixture of uppercase,lowercase,numeric and special characters"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      loader.isLoading(false);

    }else if (email.isNotEmpty && password.isNotEmpty) {
      loader.isLoading(true);
      Map<String, dynamic> map = await AuthService.loginStudent(
        email,
        password,
      );

      if (map["success"]) {
        String token = map['token'];

        await saveToken(token);
        final controller = Get.put(Controller());
        controller.isGuestIn.value = false; // user is logged in now
        controller.isLoggedIn.value = true;
        profileController.profile.value = map['student'];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(token)),
          (route) => false,
        );
        loader.isLoading(false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(map['message']),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
        loader.isLoading(false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all the required field"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: "809028962389-buh0m92ilhd1n27vkuhi1og76g9kb5v2.apps.googleusercontent.com", // From GCP OAuth Client
  );

  Future<void> _handleGoogleLogIn() async {
    try {
      final account = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth = await account!.authentication;

      Map<String, dynamic> map = await AuthService.loginViaGoogle(
        auth.idToken.toString()
      );

      if (map["success"]) {

        String token = map['token'];

        await saveToken(token);
        final controller = Get.put(Controller());
        controller.isGuestIn.value = false; // user is logged in now
        controller.isLoggedIn.value = true;

        profileController.profile.value = map['student'];

        if(map['firstTime']){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CompleteProfilePage()),
                (route) => false,
          );
        }else{
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(token)),
                (route) => false,
          );
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(map['message']),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

    } catch (error) {
      print("<-------------> Sign-in error: $error");
    }
  }

  void printLongText(String text, {int chunkSize = 800}) {
    final pattern = RegExp('.{1,$chunkSize}'); // Match strings up to chunkSize
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text: "Login",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                text: "Login here to continue to app",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),
          const Text(
            "Email",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Password",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),

              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendOtpScreen()),
                );
              },
              child: const Text(
                "Forgot Password ?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Obx(
            () =>
                !loader.isLoading.value
                    ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
                    : Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
          ),
          const SizedBox(height: 20),
          // SizedBox(
          //   width: double.infinity,
          //   height: 50,
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(2),
          //         side: const BorderSide(color: Colors.black),
          //       ),
          //       elevation: 2,
          //     ),
          //     onPressed: () async {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => Mobilenoauth()),
          //       );
          //     },
          //     icon: Icon(Icons.phone, color: Colors.black, size: 24,),
          //
          //     label: Flexible(
          //       child: Text(
          //         "Login with Mobile Number",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: const BorderSide(color: Colors.black),
                ),
                elevation: 2,
              ),
              onPressed: _handleGoogleLogIn,
              icon: Icon(Icons.email_outlined, color: Colors.black, size: 28,),
              label: Flexible(
                child: Text(
                  "Login with Gmail",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }



  // Function to save the token
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
