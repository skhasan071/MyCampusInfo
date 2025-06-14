import 'package:my_campus_info/services/shortListCollegeController.dart';
import 'package:my_campus_info/view/splash_view.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  Get.put(ThemeController());
  Get.put(ShortlistedCollegesController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(builder: (context)=>MyApp())
    //MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      // ⬅️ Make theme reactive
      builder: (themeController) {
        final theme = themeController.currentTheme;
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            iconTheme: IconThemeData(color: Colors.black),
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontFamilyFallback: ['NotoSans']),
            ),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor:
              theme
                  .selectedTextBackground, // Highlight background of selected text
              selectionHandleColor: theme.filterSelectedColor, // Drag handles
              cursorColor: theme.filterSelectedColor, // Blinking cursor
            ),
          ),

          home: SplashView(token: token ?? '',),

        );
      },
    );
  }

  Future<void> loadToken() async {
    token = await getToken() ?? '';
    setState(() {});
  }
}


// Function to get the token
Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // Will return null if no token is saved
}

// Function to save the token
Future<void> delToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

class GoogleSignInPage extends StatefulWidget {
  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {

  GoogleSignInAccount? _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: "809028962389-buh0m92ilhd1n27vkuhi1og76g9kb5v2.apps.googleusercontent.com", // From GCP OAuth Client
  );

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth = await account!.authentication;
      print('Token Id: ' + auth.idToken.toString() + ' ---->');
      setState(() {
        _user = account;
      });
    } catch (error) {
      print("<-------------> Sign-in error: $error");
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GCP Google Sign-In")),
      body: Center(
        child: _user == null
            ? ElevatedButton(
          onPressed: _handleSignIn,
          child: Text("Sign In with Google"),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_user!.photoUrl ?? ""),
              radius: 40,
            ),
            SizedBox(height: 10),
            Text("Welcome, ${_user!.displayName}"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}