import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Privacy Policy',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo and App Name section moved here, scrollable
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/appLogo.png'),
                  radius: 55,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 12),
                Text(
                  'College App',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: theme.filterSelectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Privacy policy content container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionHeader(title: "Introduction"),
                  _SectionText(
                    "We are committed to respecting your privacy. This policy explains how we handle personal information in compliance with applicable laws.",
                  ),
                  _SectionHeader(title: "Information Collection"),
                  _SectionText(
                    "We collect your username, email, department, and feedback to personalize and improve the service.",
                  ),
                  _SectionHeader(title: "Processing Personal Information"),
                  _SectionText(
                    "Your information is processed lawfully, fairly, and transparently. Only authorized users have access.",
                  ),
                  _SectionHeader(title: "Account Control"),
                  _SectionText(
                    "You can request account deletion by contacting us at privacy@collegeapp.com.",
                  ),
                  _SectionHeader(title: "Terms of Use"),
                  _SectionText(
                    "By using this app, you agree to follow our terms and policies.",
                  ),
                  _SectionHeader(title: "Cookie and Other Tracking Technology"),
                  _SectionText(
                    "We may use cookies and similar technologies to enhance your experience.",
                  ),
                  _SectionHeader(title: "Information Sharing"),
                  _SectionText(
                    "We do not share your data with third parties unless legally required.",
                  ),
                  _SectionHeader(title: "Confidentiality and Security"),
                  _SectionText(
                    "Your data is stored securely using Appwrite with access control mechanisms.",
                  ),
                  _SectionHeader(title: "Social Media"),
                  _SectionText(
                    "Links to social media do not imply endorsement. Your data is not shared with them.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Footer text
            const Center(
              child: Text(
                "© 2025 College Feedback App. All rights reserved.",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  final String text;

  const _SectionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, color: Colors.grey[800], height: 1.5),
    );
  }
}
