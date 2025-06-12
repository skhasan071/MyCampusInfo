import 'dart:convert';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

class Hostel extends StatefulWidget {
  final String
  collegeId; // Pass the selected collegeId from the previous screen

  const Hostel({required this.collegeId, super.key});

  @override
  State<Hostel> createState() => _HostelState();
}

class _HostelState extends State<Hostel> {
  bool isLoading = true;
  String errorMessage = "";
  String hostelName = "";
  List<String> hostelAmenities = [];
  List<String> campusAmenities = [];
  String hostelInfo = "";
  List<String> photos = []; // To hold the photo URLs

  @override
  void initState() {
    super.initState();
    fetchHostelDetails();
  }

  // Fetch hostel data from the API
  Future<void> fetchHostelDetails() async {
    final url =
        'https://tc-ca-server.onrender.com/api/colleges/hostel/${widget.collegeId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        hostelName = data['hostelName'] ?? "Hostel Name Not Available";
        hostelAmenities = List<String>.from(data['hostelAmenities'] ?? []);
        campusAmenities = List<String>.from(data['campusAmenities'] ?? []);
        hostelInfo = data['hostelInfo'] ?? "No information available.";
        photos = List<String>.from(data['photos'] ?? []);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching hostel data.";
      });
    }
  }

  // Method to build the amenities list using recruiter chip widget
  Widget _buildRecruiterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Hostel & Campus Life",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loader while fetching
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage)) // Show error message
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Photos (if any)
                      photos.isNotEmpty
                          ? SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Image.network(
                                    photos[index],
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 300,
                                  ),
                                );
                              },
                            ),
                          )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 16),

                      // Hostel Name
                      Text(
                        hostelName,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),

                      // Hostel Amenities
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: theme.backgroundGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: theme.boxShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hostel Amenities",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    hostelAmenities
                                        .map(
                                          (amenity) =>
                                              _buildRecruiterChip(amenity),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey, thickness: 0.5),
                      // CAMPUS FACILITIES SECTION
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: theme.backgroundGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: theme.boxShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Campus Facilities",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 12,
                                children:
                                    campusAmenities
                                        .map(
                                          (amenity) =>
                                              _buildRecruiterChip(amenity),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),

                      // Hostel Information
                      Text(hostelInfo, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
      );
    });
  }
}
