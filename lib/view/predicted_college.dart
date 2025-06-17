import 'package:my_campus_info/constants/card.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../internetCheck/connectivityChecker.dart';
import '../view_model/controller.dart';

class CollegeResultsPage extends StatefulWidget {
  const CollegeResultsPage({super.key});

  @override
  State<CollegeResultsPage> createState() => _CollegeResultPageState();
}

class _CollegeResultPageState extends State<CollegeResultsPage> {
  int selectedFilterIndex = 0;
  // List<String> filters = ['View all', 'Filter 1', 'Filter 2', 'Filter 3', 'Filter 4'];
  final controller = Get.find<Controller>();
  final profile = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return ConnectivityChecker(  // Wrap the content with ConnectivityChecker
        child:Scaffold(
        backgroundColor: Colors.white,
        body: ConnectivityChecker(  // Wrap the content with ConnectivityChecker
          child:  SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Predict Your Rank. Find Your College.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "College Predictor",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: theme.filterSelectedColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your personalized college recommendations based on your score.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      // Expanded(
                      //   child: OutlinedButton.icon(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.filter_list, color: Colors.black),
                      //     label: const Text("Filter", style: TextStyle(color: Colors.black)),
                      //     style: OutlinedButton.styleFrom(
                      //       foregroundColor: Colors.black,
                      //       side: const BorderSide(color: Colors.black),
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      //       padding: const EdgeInsets.symmetric(vertical: 12),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.navSelectedIndex.value =
                                  3; // back to predictor form
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.filterSelectedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Edit Preferences",
                                style: TextStyle(color: theme.filterTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Obx(() {
                    if (controller.predictedClg.isEmpty) {
                      return const Center(child: Text("No Colleges Found"));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 36,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: filters.length,
                        //     itemBuilder: (context, index) {
                        //       final isSelected = index == selectedFilterIndex;
                        //       return Padding(
                        //         padding: const EdgeInsets.only(right: 10),
                        //         child: TextButton(
                        //           onPressed: () {
                        //             setState(() => selectedFilterIndex = index);
                        //           },
                        //           style: TextButton.styleFrom(
                        //             backgroundColor: isSelected ? Colors.black : Colors.grey[200],
                        //             foregroundColor: isSelected ? Colors.white : Colors.black,
                        //             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(20),
                        //               side: const BorderSide(color: Colors.black),
                        //             ),
                        //           ),
                        //           child: Text(filters[index]),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        const SizedBox(height: 24),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.predictedClg.length,
                          itemBuilder: (context, index) {
                            final clg = controller.predictedClg[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CardStructure(
                                clg: clg,
                                collegeID: clg.id,
                                collegeName: clg.name,
                                feeRange: clg.feeRange,
                                state: clg.state,
                                ranking: clg.ranking.toString(),
                                studId: profile.profile.value?.id ?? '',
                                clgId: clg.id,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        )));
    });
  }
}
