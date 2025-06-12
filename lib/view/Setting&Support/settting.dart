import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view_model/controller.dart';

class SettingsPage extends StatelessWidget {
  var controller = Get.put(Controller());
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isNotificationOn = false;
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            //
            // _buildTile(
            //   title: "Update Profile",
            //   subtitle:
            //       "Update your Name, Mobile Number, Study In, Passed In, City.",
            //   icon: Icons.account_circle_outlined,
            //   onTap: () {
            //     if (controller.isGuestIn.value) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text("Please Login First"),
            //           duration: Duration(seconds: 3),
            //           backgroundColor: Colors.black,
            //           behavior: SnackBarBehavior.floating,
            //         ),
            //       );
            //     } else {
            //       controller.navSelectedIndex.value = 5;
            //     }
            //   },
            //   iconColor: const Color(0xFF1E88E5),
            // ),

            const Divider(),

            _buildTile(
              title: "Choose theme",
              subtitle: "System default",
              icon: Icons.brightness_6_outlined,
              iconColor: Color(0xFF8E24AA),
              onTap: () => Get.to(() => ThemePage()),
            ),
            const Divider(),

            StatefulBuilder(
              builder: (context, setState) {
                return SwitchListTile(
                  value: isNotificationOn,
                  onChanged: (val) {
                    setState(() => isNotificationOn = val);
                  },
                  secondary: const Icon(
                    Icons.notifications_none,
                    size: 35,
                    color: Color(0xFFF4511E),
                  ),

                  title: const Text(
                    "Notifications",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Choose when to get notified about colleges that match your filters.",
                  ),
                );
              },
            ),
            const Divider(),

            /*  _buildTile(
              title: "Language",
              subtitle: "English",
              icon: Icons.language,
              iconColor: Color(0xFF43A047),
              onTap: () => Get.to(() => const LanguagePage()),
            ),
            const Divider(),*/
            _buildTile(
              title: "Version",
              subtitle: "1.0.0",
              icon: Icons.info_outline,
              iconColor: Color(0xFF757575),
              onTap: () {},
            ),

            const Divider(),
          ],
        ),
      );
    });
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, size: 35, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: const TextStyle(fontSize: 14))
              : null,
      onTap: onTap,
    );
  }
}

class ThemePage extends StatelessWidget {
  ThemePage({super.key});

  final themeTitles = [
    "Black & White",
    "Purple",
    "Emerald",
    "Sunset",
    "Cool Blue",
  ];

  final themeColors = [
    Colors.black,
    Color(0xff4B0082),
    Colors.green,
    Color(0xFFF57C00),
    Color(0xFF1976D2),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            'Choose Theme',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Obx(() {
          final selectedIndex = ThemeController.to.selectedThemeIndex.value;

          return ListView.separated(
            itemCount: themeTitles.length,
            separatorBuilder:
                (context, index) => Divider(
                  color: Colors.grey.shade400,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              final color = themeColors[index];

              return ListTile(
                onTap: () => ThemeController.to.changeTheme(index),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  themeTitles[index],
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Cursive',
                    color: color,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing:
                    isSelected ? Icon(Icons.check_circle, color: color) : null,
              );
            },
          );
        }),
      );
    });
  }
}

/*class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  final List<String> languages = const [
    'English',
    'Hindi',
    'Tamil',
    'Gujarati',
    'Marathi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Language')),
      body: ListView.separated(
        itemCount: languages.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            onTap: () {
              // TODO: Apply selected language logic here
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}*/
