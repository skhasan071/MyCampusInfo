import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Scholarships extends StatefulWidget {
  final String collegeId;
  final String collegeName;

  const Scholarships({
    required this.collegeId,
    required this.collegeName,
    super.key,
  });

  @override
  _ScholarshipsState createState() => _ScholarshipsState();
}

class _ScholarshipsState extends State<Scholarships> {
  late List<dynamic> scholarships = [];
  late double averageFinancialAid = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScholarships();
  }

  Future<void> fetchScholarships() async {
    final result = await fetchScholarshipByCollegeId(widget.collegeId);

    if (result['status'] == 200) {
      setState(() {
        scholarships = (result['data'] as List).map((scholarship) {
          return {
            'ScholarshipName': scholarship['ScholarshipName'] ?? 'No name provided',
            'ScholarshipMoney': scholarship['ScholarshipMoney'] ?? 0,
            'ScholarshipDescription': scholarship['ScholarshipDescription'] ?? 'No description provided',
          };
        }).toList();

        averageFinancialAid = calculateAverageFinancialAid(scholarships);
        _isLoading = false;
      });
    } else {
      setState(() {
        scholarships = [];
        _isLoading = false;
      });
      print('Error fetching scholarships: ${result['data']}');
    }
  }

  Future<Map<String, dynamic>> fetchScholarshipByCollegeId(String collegeId) async {
    final url = Uri.parse('http://3.7.169.233:8080/api2/colleges/scholarships/$collegeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final scholarships = data['scholarships']; // Extract the array
        return {'status': 200, 'data': scholarships};
      } else {
        final data = jsonDecode(response.body);
        return {'status': response.statusCode, 'data': data};
      }
    } catch (e) {
      print("Error fetching scholarship: $e");
      return {'status': 500, 'data': e.toString()};
    }
  }

  double calculateAverageFinancialAid(List<dynamic> scholarships) {
    double totalAid = 0.0;
    int validScholarships = 0;

    for (var scholarship in scholarships) {
      if (scholarship['ScholarshipMoney'] != null) {
        totalAid += scholarship['ScholarshipMoney'];
        validScholarships++;
      }
    }

    return validScholarships > 0 ? totalAid / validScholarships : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('${widget.collegeName} - Scholarships & Aid'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: theme.backgroundGradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        "Average Cost Calculated",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.filterSelectedColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Financial Aid',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${averageFinancialAid.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'per year',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 16),
              Text(
                'Available Scholarships',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: theme.filterSelectedColor,
                ),
              ),
              const SizedBox(height: 12),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: theme.filterSelectedColor,
                ),
              )
                  : scholarships.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scholarships.length,
                itemBuilder: (context, index) {
                  return _buildScholarshipTile(
                    title: scholarships[index]['ScholarshipName'],
                    subtitle: '\$${scholarships[index]['ScholarshipMoney']} per year',
                    description: scholarships[index]['ScholarshipDescription'],
                  );
                },
              )
                  : const Center(
                child: Text("No scholarships found for this college"),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildScholarshipTile({
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Container(
          decoration: BoxDecoration(
            gradient: theme.backgroundGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: Colors.black)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle tap
            },
          ),
        ),
      );
    });
  }
}
