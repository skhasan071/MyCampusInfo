import 'package:flutter/material.dart';

class CustomTheme {
  final Color brochureBtnColor; // card.dart
  final Color starColor;
  final Color nirfTextColor;
  final Color courseCountColor;
  final Color filterSelectedColor; // filter.dart
  final Color filterTextColor;
  final LinearGradient backgroundGradient; //College.dart
  final LinearGradient boxGradient;
  final List<BoxShadow> boxShadow;
  final Color saveIconColor;
  final Color bottomNav;
  final Color bottomIcons;
  final LinearGradient chipGradient;
  final Color selectedTextBackground;

  const CustomTheme({
    required this.brochureBtnColor,
    required this.starColor,
    required this.nirfTextColor,
    required this.courseCountColor,
    required this.filterSelectedColor,
    required this.filterTextColor,
    required this.backgroundGradient,
    required this.boxGradient,
    required this.boxShadow,
    required this.saveIconColor,
    required this.bottomNav,
    required this.bottomIcons,
    required this.chipGradient,
    required this.selectedTextBackground,
  });
}

class AppThemes {
  static final blackWhiteTheme = CustomTheme(
    brochureBtnColor: Colors.black,
    starColor: Colors.black,
    nirfTextColor: Colors.black,
    courseCountColor: Colors.black,
    filterSelectedColor: Colors.black,
    filterTextColor: Colors.white,
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.grey.shade200,
        Colors.grey.shade400,
        Colors.grey.shade600,
      ],
    ),
    boxGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade800..withOpacity(0.3),
        blurRadius: 14,
        spreadRadius: 2,
        offset: Offset(0, 6),
      ),
    ],
    saveIconColor: Colors.black,
    bottomNav: Colors.black,
    bottomIcons: Colors.white,
    chipGradient: LinearGradient(colors: [Colors.white, Colors.grey]),
    selectedTextBackground: Colors.black.withOpacity(0.25),
  );

  static final coloredTheme = CustomTheme(
    brochureBtnColor: Colors.green,
    starColor: Colors.amber,
    nirfTextColor: Colors.green,
    courseCountColor: Colors.blue,
    filterSelectedColor: Color(0xff4B0082),
    filterTextColor: Colors.white,
    backgroundGradient: const LinearGradient(
      begin: Alignment(-0.9, -0.9),
      end: Alignment(1.2, 1.2),
      colors: [
        Color(0xFFF8F2FC),
        Color(0xFFEADFF9),
        Color(0xFFDBC9F1),
        Color(0xFFD2C0ED),
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
      tileMode: TileMode.clamp,
    ),

    boxGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFDDEEFF), Color(0xFFB3D1F1)],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFFB197D8).withOpacity(0.1),
        blurRadius: 14,
        spreadRadius: 2,
        offset: Offset(0, 6),
      ),
    ],
    saveIconColor: Colors.black,
    bottomNav: Color(0xFFEEE6F6),
    bottomIcons: Colors.black,
    chipGradient: LinearGradient(
      colors: [Color(0xFFF4EFFF), Color(0xFFE1D9F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    selectedTextBackground: Color(0x884B0082).withOpacity(0.25),
  );

  static final emeraldTheme = CustomTheme(
    brochureBtnColor: Color(0xFF2E7D32),
    starColor: Color(0xFFFFC107),
    nirfTextColor: Color(0xFF1B5E20),
    courseCountColor: Color(0xFF388E3C),
    filterSelectedColor: Color(0xFF1B5E20),
    filterTextColor: Colors.white,
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF1F8F5), Color(0xFFD0EAD9), Color(0xFFA5D6A7)],
    ),
    boxGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD0F0C0), Color(0xFFB2DFDB)],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF81C784).withOpacity(0.2),
        blurRadius: 12,
        spreadRadius: 2,
        offset: Offset(0, 6),
      ),
    ],
    saveIconColor: Color(0xFF2E7D32),
    bottomNav: Color(0xFFE0F4E9),
    bottomIcons: Colors.black,
    chipGradient: LinearGradient(
      colors: [Color(0xFFE8F5E9), Color(0xFFD0F0C0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    selectedTextBackground: Color(0x881B5E20).withOpacity(0.25),
  );

  static final sunsetTheme = CustomTheme(
    brochureBtnColor: Color(0xFFFF7043),
    starColor: Color(0xFFFFC107),
    nirfTextColor: Color(0xFFE64A19),
    courseCountColor: Color(0xFFFF8A65),
    filterSelectedColor: Color(0xFFD84315),
    filterTextColor: Colors.white,
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
    ),
    boxGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFE0B2), Color(0xFFFFAB91)],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFFFF7043).withOpacity(0.15),
        blurRadius: 12,
        spreadRadius: 2,
        offset: Offset(0, 5),
      ),
    ],
    saveIconColor: Color(0xFFE64A19),
    bottomNav: Color(0xFFFFF0E6),
    bottomIcons: Colors.black,
    chipGradient: LinearGradient(
      colors: [Color(0xFFFFF3E0), Color(0xFFFFCCBC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    selectedTextBackground: Color(0x88D84315).withOpacity(0.25),
  );

  static final coolBlueTheme = CustomTheme(
    brochureBtnColor: Color(0xFF1E88E5),
    starColor: Color(0xFFFFD600),
    nirfTextColor: Color(0xFF0D47A1),
    courseCountColor: Color(0xFF42A5F5),
    filterSelectedColor: Color(0xFF1976D2),
    filterTextColor: Colors.white,
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
    ),
    boxGradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF64B5F6).withOpacity(0.2),
        blurRadius: 12,
        spreadRadius: 2,
        offset: Offset(0, 5),
      ),
    ],
    saveIconColor: Color(0xFF1E88E5),
    bottomNav: Color(0xFFE3F2FD),
    bottomIcons: Colors.black,
    chipGradient: LinearGradient(
      colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    selectedTextBackground: Color(0x881976D2).withOpacity(0.25),
  );
}
