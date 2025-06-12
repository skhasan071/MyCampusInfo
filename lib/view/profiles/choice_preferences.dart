import 'package:my_campus_info/main.dart';
import 'package:my_campus_info/services/user_services.dart';
import 'package:my_campus_info/view/SignUpLogin/FirstPage.dart';
import 'package:my_campus_info/view/home_page.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/ui_helper.dart';

class CoursePreferencesPage extends StatefulWidget {
  final bool isFlow;
  const CoursePreferencesPage({required this.isFlow, super.key});

  @override
  State<CoursePreferencesPage> createState() => _CoursePreferencesPageState();
}

class _CoursePreferencesPageState extends State<CoursePreferencesPage> {

  final List<String> streams = [
    'Engineering', 'Management', 'Arts', 'Science', 'Law',
    'Medical', 'Design', 'Humanities'
  ];

  final Map<String, List<String>> courses = {
    'Engineering': [
      'B.Tech in Computer Science & Engineering',
      'B.Tech in Mechanical Engineering',
      'B.Tech in Civil Engineering',
      'B.Tech in Electrical Engineering',
      'B.Tech in Electronics & Communication Engineering',
      'B.Tech in Chemical Engineering',
      'B.Tech in Information Technology',
      'M.Tech in Computer Science',
      'M.Tech in Mechanical Engineering',
      'M.Tech in Electronics Engineering',
    ],
    'Management': [
      'BBA (Bachelor of Business Administration)',
      'MBA (Master of Business Administration)',
      'BBA in Marketing',
      'MBA in Marketing',
      'BBA in Finance',
      'MBA in Finance',
      'MBA in Human Resource Management',
      'MBA in International Business',
      'MBA in Operations Management',
      'PGDM (Post Graduate Diploma in Management)',
    ],
    'Arts': [
      'BA in English',
      'BA in History',
      'BA in Political Science',
      'BA in Psychology',
      'BA in Sociology',
      'BA in Economics',
      'BA in Philosophy',
      'BA in Geography',
      'BA in Public Administration',
      'BA in Journalism & Mass Communication',
    ],
    'Science': [
      'BSc in Physics',
      'BSc in Chemistry',
      'BSc in Mathematics',
      'BSc in Computer Science',
      'BSc in Biotechnology',
      'BSc in Microbiology',
      'BSc in Environmental Science',
      'BSc in Zoology',
      'BSc in Botany',
      'BSc in Statistics',
    ],
    'Law': [
      'BA LLB (Hons.)',
      'BBA LLB',
      'BCom LLB',
      'LLB (3 Years)',
      'LLM (Corporate Law)',
      'LLM (International Law)',
      'LLM (Constitutional Law)',
      'Diploma in Cyber Law',
      'Diploma in Intellectual Property Rights',
      'Certificate in Environmental Law',
    ],
    'Medical': [
      'MBBS',
      'BDS (Bachelor of Dental Surgery)',
      'BAMS (Ayurveda)',
      'BHMS (Homeopathy)',
      'BPT (Physiotherapy)',
      'BSc Nursing',
      'BPharm (Pharmacy)',
      'BNYS (Naturopathy & Yogic Science)',
      'BMLT (Medical Lab Technology)',
      'BOT (Occupational Therapy)',
    ],
    'Design': [
      'Bachelor of Design (B.Des)',
      'B.Des in Fashion Design',
      'B.Des in Graphic Design',
      'B.Des in Interior Design',
      'B.Des in Product Design',
      'B.Des in Industrial Design',
      'B.Des in Textile Design',
      'B.Des in Animation & Multimedia',
      'B.Des in Visual Communication',
      'B.Des in UX/UI Design',
    ],
    'Humanities': [
      'BA in Philosophy',
      'BA in Psychology',
      'BA in Sociology',
      'BA in History',
      'BA in Political Science',
      'BA in Linguistics',
      'BA in Literature',
      'BA in Anthropology',
      'BA in Education',
      'BA in Gender Studies',
    ],
  };

  final List<String> levels = ['UG', 'PG', 'Diploma/Certification'];
  final List<String> modes = ['Full-time', 'Part-time', 'Online', 'Distance learning'];
  final List<String> years = ['2025', '2026', 'Later'];

  Set<String> selectedStreams = {};
  Set<String> selectedCourses = {};
  String? selectedLevel;
  String? selectedMode;
  String? selectedYear;

  var pfpCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(pfpCtrl.userToken.value)), (route)=>false);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
        
          backgroundColor: Colors.white,
        
          body: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close Button
                  !widget.isFlow
                      ? Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(pfpCtrl.userToken.value)), (route)=>false);
                        },
                      ),
                    )
                      : SizedBox.shrink(),
        
                  const SizedBox(height: 12),
                  const Text("Course Preferences", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose preferences to explore colleges you prefer.",
                    style: TextStyle(color: Colors.black54,),
                  ),
                  const SizedBox(height: 24),
        
                  _buildSectionTitle("Interested Streams"),
                  _buildChips(streams, selectedStreams, isMulti: true),
        
                  SizedBox(height: selectedStreams.isNotEmpty ? 16 : 0),
                  selectedStreams.isNotEmpty ? _buildSectionTitle("Course(s) Interested In") : SizedBox.shrink(),
                  selectedStreams.isNotEmpty
                      ? _buildChips(
                    _getCoursesForSelectedStreams(),
                    selectedCourses,
                    isMulti: true,
                  ) : SizedBox.shrink(),
        
                  const SizedBox(height: 16),
                  _buildSectionTitle("Preferred Course Level"),
                  _buildChips(levels, {selectedLevel}, isMulti: false, onChanged: (val) => setState(() => selectedLevel = val)),
        
                  const SizedBox(height: 16),
                  _buildSectionTitle("Mode of Study"),
                  _buildChips(modes, {selectedMode}, isMulti: false, onChanged: (val) => setState(() => selectedMode = val)),
        
                  const SizedBox(height: 16),
                  _buildSectionTitle("Preferred year of admission (optional)"),
                  _buildChips(years, {selectedYear}, isMulti: false, onChanged: (val) => setState(() => selectedYear = val)),
        
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
        
                      UiHelper.getSecondaryBtn(title: "Back", callback: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Firstpage()));
                      }),
        
                      UiHelper.getPrimaryBtn(title: "Next", callback: () async {
                        pfpCtrl.userToken.value = await getToken() ?? "";
                        if (pfpCtrl.userToken.value != "") {

                          print(selectedStreams.toList());
                          print(selectedCourses.toList());
                          pfpCtrl.profile.value!.interestedStreams = selectedStreams.toList();
                          pfpCtrl.profile.value!.coursesInterested = selectedCourses.toList();
                          print(pfpCtrl.profile.value!.interestedStreams);
                          print(pfpCtrl.profile.value!.coursesInterested);
                          pfpCtrl.profile.value!.preferredCourseLevel = selectedLevel ?? "UG";
                          pfpCtrl.profile.value!.modeOfStudy = selectedMode ?? "Full-time";
                          pfpCtrl.profile.value!.preferredYearOfAdmission = selectedYear ?? "2025";
        
                          Map<String, dynamic>? data = await StudentService.saveCoursePreferences(
                            token: pfpCtrl.userToken.value,
                            coursesInterested: selectedCourses.toList(),
                            interestedStreams: selectedStreams.toList(),
                            modeOfStudy: selectedMode ?? "Full-time",
                            preferredCourseLevel: selectedLevel ?? "UG",
                            preferredYearOfAdmission: selectedYear ?? "2025",
                          );
        
                        } else {
                          pfpCtrl.interestedStreams.value = selectedStreams.toList();
                          pfpCtrl.coursesInterested.value = selectedCourses.toList();
                        }
        
                        if (widget.isFlow) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(pfpCtrl.userToken.value)),
                                (route) => false,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(pfpCtrl.userToken.value)),
                                (route) => false,
                          );
                        }
                      }),
        
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getCoursesForSelectedStreams() {
    List<String> allCourses = [];
    for (var stream in selectedStreams) {
      allCourses.addAll(courses[stream] ?? []);
    }
    return allCourses;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
    );
  }

  Widget _buildChips(List<String> options, Set<String?> selectedValues, {
    bool isMulti = false,
    Function(String)? onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final isSelected = selectedValues.contains(item);
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          selectedColor: Colors.black,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          onSelected: (_) {
            setState(() {
              if (isMulti) {
                isSelected ? selectedValues.remove(item) : selectedValues.add(item);
              } else {
                selectedValues.clear();
                selectedValues.add(item);
                if (onChanged != null) onChanged(item);
              }
            });
          },
        );
      }).toList(),
    );
  }
}