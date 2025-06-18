import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_campus_info/view_model/controller.dart';
import '../internetCheck/connectivityChecker.dart';
import '../model/college.dart';
import '../services/college_services.dart';

class CollegePredictorPage extends StatefulWidget {
  const CollegePredictorPage({super.key});

  @override
  State<CollegePredictorPage> createState() => _CollegePredictorScreenState();
}

class _CollegePredictorScreenState extends State<CollegePredictorPage> {
  String? selectedState = "Select";
  String? selectedCategory = "Select";
  String? selectedExam = "Select";
  String? selectedRankType = "Select";
  String rank = '';

  var controller = Get.find<Controller>();

  final List<String> rankTypes = ['Percentile', "Rank","Percentage"];
  final List<String> states = [
    'Delhi',
    'Maharashtra',
    'Gujarat',
    'Karnataka',
    'Tamil Nadu',
    'West Bengal',
  ];

  final List<String> exams = [
    "JEE",
    "MHT-CET",
    "CET",
    "NEET",
    "BITSAT",
    "VITEEE",
    //new
    "CAT",
    "CLAT",
    "MH-CET LAW",
    "MAH-CET",
    "SLAT",
    "HSC",
    "SSC",
    "CUET",
    "IPU-CET",
    "KLEE",
    "KEAM",
    "GUJCET",
    "SAJEE",
    "SRMHCAT",
    "TNEA",

  ];

  final List<String> categories = [
    'General',
    'OBC',
    'SC',
    'ST',
    'EWS',
    'PWD',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    selectedExam = "Select";
    selectedCategory = "Select";
    selectedRankType = "Select";
    rank = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return MaterialApp(  // Ensure MaterialApp is here to provide Material context
          home:Scaffold(
        backgroundColor: Colors.white,
        body:  ConnectivityChecker(  // Wrap only the body content
          child:SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Score. Your College.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "College Predictor",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: theme.filterSelectedColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Discover the colleges where you have the best chance of admission based on your scores.",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 23),

                _buildLabel("Select your Exam"),
                _buildDropdown(selectedExam, (value) {
                  setState(() => selectedExam = value);
                }, exams),

                _buildLabel("Select your State"),
                _buildDropdown(selectedState, (value) {
                  setState(() => selectedState = value);
                }, states),

                _buildLabel("Select your category"),
                _buildDropdown(selectedCategory, (value) {
                  setState(() => selectedCategory = value);
                }, categories),

                _buildLabel("Select your Rank Type"),
                _buildDropdown(selectedRankType, (value) {
                  setState(() => selectedRankType = value);
                }, rankTypes),

                const SizedBox(height: 14),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: "# Enter your rank / percentile",
                  ),
                  onChanged: (val) => rank = val,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6, // 60% width
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check if all fields are filled and not set to "Select"
                        if (selectedExam == "Select" ||
                            selectedState == "Select" ||
                            selectedCategory == "Select" ||
                            selectedRankType == "Select" ||
                            rank.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all fields before proceeding.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 4),
                            ),
                          );
                          return;
                        }

                        // Check if the selected exam and state match
                        if (selectedExam == "MHT-CET" &&
                            selectedState != "Maharashtra") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "MHT-CET is not valid for ${selectedState ?? 'this state'}. Please select Maharashtra or change exam.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 4),
                            ),
                          );
                          return; // Don't proceed
                        }

                        List<College> colleges =
                            await CollegeServices.predictColleges(
                              examType: selectedExam!,
                              category: selectedCategory!,
                              rankType: selectedRankType!,
                              rankOrPercentile: rank,
                              state: selectedState!,
                            );

                        controller.predictedClg.value = colleges;
                        controller.navSelectedIndex.value = 6;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.filterSelectedColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No curve
                        ),
                      ),
                      child: Text(
                        "Get Colleges",
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.filterTextColor,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 12),  // Space between TextField and disclaimer
                Text(
                  "Predictions are based on available data and may not reflect actual outcomes",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF757575),
                    height: 1,  // Add space between lines
                  ),
                  textAlign: TextAlign.center,  // Align text to the center
                ),
              ],
            ),
          ),
        ),
      )));
    });
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String? selectedValue,
    ValueChanged<String?> onChanged,
    List<String> list,
  ) {
    final theme = ThemeController.to.currentTheme;
    return DropdownButtonFormField<String>(
      value: selectedValue, // Default value is set to the selectedValue
      items: [
        // Add a "Select" option as the first item in the list
        DropdownMenuItem(value: "Select", child: Text("Select")),
        ...list.map((opt) {
          return DropdownMenuItem(value: opt, child: Text(opt));
        }).toList(),
      ],
      onChanged: onChanged,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.filterSelectedColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
