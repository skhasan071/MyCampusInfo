import 'package:my_campus_info/services/shortListCollegeController.dart';
import 'package:my_campus_info/view/splash_view.dart';
import 'package:my_campus_info/view/splash_view_2.0.dart';
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
    MyApp(),
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