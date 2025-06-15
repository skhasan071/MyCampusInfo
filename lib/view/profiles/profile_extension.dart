import 'package:my_campus_info/constants/ui_helper.dart';
import 'package:my_campus_info/view/profiles/choice_preferences.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationPreferenceCards extends StatefulWidget {

  const EducationPreferenceCards({super.key});

  @override
  State<EducationPreferenceCards> createState() => _EducationPreferenceCardsState();
}

class _EducationPreferenceCardsState extends State<EducationPreferenceCards> {
  var pfpController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card 1: Based on Preferences
        UiHelper.getCard(width: double.infinity, widget: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Based on your preferences',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CoursePreferencesPage(isFlow: false)));
                  }, icon: Icon(Icons.edit, size: 18),),
                ],
              ),
              Divider(),
              const SizedBox(height: 8),
              const Text(
                'Education',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '${pfpController.profile.value!.interestedStreams!.join(", ")}, ${pfpController.profile.value!.preferredCourseLevel ?? ""}, ${pfpController.profile.value!.modeOfStudy ?? ""}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.75)),
                softWrap: true, // This ensures wrapping
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              const Text(
                'Interested Courses',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                pfpController.profile.value!.coursesInterested!.isEmpty
                    ? "No Courses selected yet"
                    : pfpController.profile.value!.coursesInterested!.join(", "),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.75)),
                softWrap: true,
              ),
              SizedBox(height: pfpController.profile.value!.state == null  && pfpController.profile.value!.studyingIn == null && pfpController.profile.value!.city == null ? 0 : 16),
              Text(
                pfpController.profile.value!.state == null  && pfpController.profile.value!.studyingIn == null && pfpController.profile.value!.city == null ? '' : 'Location',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: pfpController.profile.value!.state == null  && pfpController.profile.value!.studyingIn == null && pfpController.profile.value!.city == null ? 0 : 8),
              Row(
                children: [
                  pfpController.profile.value!.state == null ? SizedBox.shrink() : Icon(Icons.location_on_outlined, size: 18),
                  SizedBox(width: pfpController.profile.value!.state == null ? 0 : 4),
                  Text('${pfpController.profile.value!.state ?? ''} ${pfpController.profile.value!.city ?? ''}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.75)),),
                  SizedBox(width: pfpController.profile.value!.state == null ? 0 : 16),
                  pfpController.profile.value!.studyingIn == null ? SizedBox.shrink() : Icon(Icons.access_time, size: 18),
                  SizedBox(width: pfpController.profile.value!.state == null ? 0 : 4),
                  Text(pfpController.profile.value!.studyingIn ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.75)),),
                ],
              ),
              SizedBox(height: pfpController.profile.value!.state == null  && pfpController.profile.value!.studyingIn == null && pfpController.profile.value!.city == null ? 0 : 8),
              Divider(),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CoursePreferencesPage(isFlow: false)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'View Full Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ],
          ),
        )),
        //
        // SizedBox(height: 10,),
        //
        // // Card 2: Current Study Status
        // UiHelper.getCard(width: double.infinity, widget: Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: const [
        //       Text(
        //         'Studying In',
        //         style: TextStyle(color: Colors.grey),
        //       ),
        //       Text(
        //         '12th - Passed',
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(height: 12),
        //       Text(
        //         'Passed In',
        //         style: TextStyle(color: Colors.grey),
        //       ),
        //       Text(
        //         '2025',
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        // ))
      ],
    );
  }
}
