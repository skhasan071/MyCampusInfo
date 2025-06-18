import 'dart:convert';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

class Admission extends StatefulWidget {
  const Admission({super.key, required this.collegeId});

  final String collegeId; // Pass collegeId from the previous page

  @override
  _AdmissionState createState() => _AdmissionState();
}

class _AdmissionState extends State<Admission> {
  bool isLoading = true;
  String errorMessage = "";
  late AdmissionProcess admissionProcess;

  // Fetch admission process data from API
  Future<void> fetchAdmissionProcess() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://tc-ca-server.onrender.com/api/colleges/admission/${widget.collegeId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          admissionProcess = AdmissionProcess.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load admission process.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Cannot fetch data please retry.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdmissionProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Admissions Details',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: theme.backgroundGradient,

                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Important Dates",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: theme.filterSelectedColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _dateTile(
                              "Application Start",
                              admissionProcess.startDate,
                              "Active",
                            ),
                            const SizedBox(height: 12),
                            _dateTile(
                              "Application Deadline",
                              admissionProcess.endDate,
                              "75 days left",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: theme.backgroundGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Required Exams",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: theme.filterSelectedColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...admissionProcess.requiredExams.map(
                              (exam) => _examTile(exam, "For All Programs"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Divider(color: Colors.grey, thickness: 1),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: theme.backgroundGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admission Process",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: theme.filterSelectedColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              admissionProcess
                                  .applicationProcess, // Display the string directly
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: theme.backgroundGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Required Documents",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: theme.filterSelectedColor,
                              ),
                            ),
                            _requiredDocuments(
                              title: "Documents Required",
                              items: admissionProcess.documentsRequired,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      );
    });
  }

  // Method for Date Tile
  Widget _dateTile(String title, String date, String badgeText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 24, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Method for Exam Tile
  Widget _examTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method for Admission Steps

  // Method for Required Documents
  Widget _requiredDocuments({
    required String title,
    required List<String> items,
  }) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: theme.filterSelectedColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e, style: TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Model for Admission Process
class AdmissionProcess {
  final String collegeId;
  final List<String> requiredExams;
  final String applicationProcess;
  final String startDate;
  final String endDate;
  final List<String> documentsRequired;

  AdmissionProcess({
    required this.collegeId,
    required this.requiredExams,
    required this.applicationProcess,
    required this.startDate,
    required this.endDate,
    required this.documentsRequired,
  });

  // Factory constructor to create an instance from JSON
  factory AdmissionProcess.fromJson(Map<String, dynamic> json) {
    return AdmissionProcess(
      collegeId: json['collegeId'],
      requiredExams: List<String>.from(json['requiredExams']),
      applicationProcess: json['applicationProcess'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      documentsRequired: List<String>.from(json['documentsRequired']),
    );
  }
}
