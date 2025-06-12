import 'dart:convert';
import 'package:my_campus_info/view_model/controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../SignUpLogin/login.dart';

class SupportPage extends StatefulWidget {
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  var controller = Get.put(Controller());
  bool isSnackBarActive = false;
  bool isSnackBarActionClicked = false;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,

          title: const Text(
            'Support & Help',
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
            _featuresSection(),
            _buildDivider(),
            const Text(
              "Need help with the app? We've got you.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _subSectionTitle("FAQs:"),
            const FAQItem(
              question: "How do I log in?",
              answer:
                  "Go to the login screen, enter your enrollment ID and password, then tap 'Login'.",
            ),
            const FAQItem(
              question: "How do I reset my password?",
              answer:
                  "Tap 'Forgot Password' on the login screen and follow the instructions to reset it.",
            ),
            const FAQItem(
              question: "I submitted the wrong feedback — what do I do?",
              answer:
                  "Contact your department head or email us to report it. We will guide you accordingly.",
            ),
            const FAQItem(
              question: "Can I edit my feedback?",
              answer:
                  "No, once submitted, feedback cannot be changed. You may contact your department for help.",
            ),
            const FAQItem(
              question: "How do I search for colleges?",
              answer:
                  "Use the search bar on the home page to find colleges by name, course, or location.",
            ),
            const FAQItem(
              question: "How does the college predictor work?",
              answer:
                  "The predictor uses your entrance exam score and preferences to suggest suitable colleges.",
            ),
            const FAQItem(
              question: "Can I compare more than two colleges at once?",
              answer:
                  "Currently, you can compare two colleges side-by-side. We plan to support more soon.",
            ),
            const FAQItem(
              question: "How is the ranking calculated?",
              answer:
                  "Our rankings consider factors like placement stats, faculty, infrastructure, and student reviews.",
            ),
            _buildDivider(),
            _subSectionTitle("Contact Us:"),
            _infoRichText("Email: ", "contact-us hr@talentconnectss.com."),
            _infoRichText(
              "Response Time: ",
              "Available 24 hours from Monday to Saturday",
            ),
            _buildDivider(),
            _subSectionTitle("Report an Issue:"),
            _actionTile(
              title: "Tap here to report an issue",
              icon: Icons.report_problem,
              subtitle: "Report any issues to ensure a smooth experience.",
              onTap: () {
                if (controller.isGuestIn.value) {
                  if (isSnackBarActive)
                    return; // Prevent showing multiple snackbars

                  isSnackBarActive = true;
                  isSnackBarActionClicked = false;

                  final snackBar = SnackBar(
                    content: Text(
                      "Please Login First",
                      style: TextStyle(color: theme.filterTextColor),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: theme.filterSelectedColor,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Login',
                      textColor: theme.filterTextColor,
                      onPressed: () {
                        if (!isSnackBarActionClicked) {
                          isSnackBarActionClicked = true;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(snackBar).closed.then((_) {
                    isSnackBarActive = false;
                    isSnackBarActionClicked = false;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportIssuePage()),
                  );
                }
              },
            ),

            _buildDivider(),
            _subSectionTitle("Feedback:"),
            _actionTile(
              title: "Share your thoughts",
              icon: Icons.feedback,
              subtitle:
                  "Share your thoughts to help us grow - We value your opinion, share your feedback with us.",
              onTap: () {
                if (controller.isGuestIn.value) {
                  if (isSnackBarActive)
                    return; // Prevent showing multiple snackbars

                  isSnackBarActive = true;
                  isSnackBarActionClicked = false;

                  final snackBar = SnackBar(
                    content: Text(
                      "Please Login First",
                      style: TextStyle(color: theme.filterTextColor),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: theme.filterSelectedColor,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Login',
                      textColor: theme.filterTextColor,
                      onPressed: () {
                        if (!isSnackBarActionClicked) {
                          isSnackBarActionClicked = true;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(snackBar).closed.then((_) {
                    isSnackBarActive = false;
                    isSnackBarActionClicked = false;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  );
                }
              },
            ),
            _buildDivider(),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "© 2025 College App. All rights reserved.",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _featuresSection() {
    final theme = ThemeController.to.currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSectionTitle("App Features:"),
        _featureTile(
          icon: Icons.school,
          title: "College Search",
          description:
              "Easily find colleges by name,stream, or location with smart filters.",
        ),
        _featureTile(
          icon: Icons.compare,
          title: "College Comparison",
          description:
              "Compare two colleges side-by-side based on key factors.",
        ),
        _featureTile(
          icon: Icons.assessment,
          title: "College Predictor",
          description:
              "Use your exam scores and preferences to get personalized suggestions.",
        ),
        _featureTile(
          icon: Icons.feedback,
          title: "Personal Counseling",
          description:
              "Yes, we care about your well-being. Please contact your college counselor or write to us at hr@talentconnectss.com. We’ll connect you with the right help.",
        ),
      ],
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = ThemeController.to.currentTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subSectionTitle(String text) {
    final theme = ThemeController.to.currentTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: theme.filterSelectedColor,
        ),
      ),
    );
  }

  Widget _infoRichText(
    String label,
    String detail, {
    Color? labelColor,
    Color? detailColor,
  }) {
    final theme = ThemeController.to.currentTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(color: labelColor ?? Colors.black),
            ),
            TextSpan(
              text: detail,
              style: TextStyle(color: detailColor ?? theme.filterSelectedColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    final theme = ThemeController.to.currentTheme;
    return ListTile(
      leading: Icon(icon, color: theme.filterSelectedColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              )
              : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.8, height: 30);
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer, super.key});

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: const Icon(Icons.question_answer, color: Colors.black),
          title: Text(
            widget.question,
            style: const TextStyle(
              fontSize: 19,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 52.0, right: 8, bottom: 10),
            child: Text(
              widget.answer,
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
            ),
          ),
      ],
    );
  }
}

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final theme = ThemeController.to.currentTheme;

  Future<void> submitIssue() async {
    const url = 'https://tc-ca-server.onrender.com/api/colleges/report';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'issueType': issueType,
          'profession': profession,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'description': _descriptionController.text.trim(),
          'stepsToReproduce': _reproduceController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Issue reported successfully",
              style: TextStyle(color: theme.filterTextColor),
            ),
            backgroundColor: theme.filterSelectedColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to submit issue",
              style: TextStyle(color: theme.filterTextColor),
            ),
            backgroundColor: theme.filterSelectedColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reproduceController = TextEditingController();

  String issueType = 'App crash';
  String? profession;

  final issueTypes = [
    'App crash',
    'Incorrect data',
    'UI glitch',
    'Login issue',
    'Other',
  ];
  final professions = ['Student', 'Employee', 'Visitor', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _reproduceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Report an Issue',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: theme.filterSelectedColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: issueType,
                  items:
                      issueTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      issueType = val!;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Issue Type',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: profession,
                  items:
                      professions
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      profession = val!;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Profession is required"
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? "Name is required"
                              : null,
                ),
                const SizedBox(height: 16),
                /* TextField(
                  controller: _emailController,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Email (optional)",
                      labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),*/
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Issue Description",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? "Description is required"
                              : null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reproduceController,
                  maxLines: 3,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Steps to Reproduce (optional)",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        submitIssue();
                      }
                    },

                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.filterSelectedColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final theme = ThemeController.to.currentTheme;
  Future<void> submitFeedback() async {
    const url = 'https://tc-ca-server.onrender.com/api/colleges/feedback';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'feedbackType': feedbackType,
          'profession': profession,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'feedback': _feedbackController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Feedback Submitted successfully",
              style: TextStyle(color: theme.filterTextColor),
            ),
            backgroundColor: theme.filterSelectedColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to submit Feedback",
              style: TextStyle(color: theme.filterTextColor),
            ),
            backgroundColor: theme.filterSelectedColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();

  String feedbackType = 'Suggestion';
  String? profession;

  final feedbackTypes = ['Suggestion', 'Compliment', 'Complaint', 'General'];
  final professions = ['Student', 'Employee', 'Visitor', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Feedback',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: theme.filterSelectedColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: feedbackType,
                  items:
                      feedbackTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      feedbackType = val!;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Feedback Type',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: profession,
                  items:
                      professions
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      profession = val!;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Profession is required"
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? "Name is required"
                              : null,
                ),

                const SizedBox(height: 16),
                /*   TextField(
                  controller: _emailController,
                    cursorColor: theme.filterSelectedColor,
                  decoration:  InputDecoration(
                    labelText: "Email (optional)",
                   labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),*/
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 4,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    labelText: "Your Feedback",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? "Feedback is required"
                              : null,
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Handle submission
                        submitFeedback();
                      }
                    },

                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          theme.filterSelectedColor, // dynamic theme color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
