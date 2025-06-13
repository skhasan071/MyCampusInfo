import 'package:my_campus_info/constants/customTheme.dart';
import 'package:my_campus_info/model/college.dart';
import 'package:my_campus_info/services/user_services.dart';
import 'package:my_campus_info/view/DetailPage/collegeDetail.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:my_campus_info/constants/colors.dart';
import 'package:my_campus_info/view_model/saveController.dart';
import 'package:get/get.dart';

import '../model/course.dart';
import '../services/college_services.dart';
import '../view/SignUpLogin/login.dart';
import '../view_model/controller.dart';

class CardStructure extends StatefulWidget {
  final bool showTwoButtons;
  final bool disableCardTap;
  final VoidCallback? onDetailTap;
  final String collegeID;
  final String collegeName;
  final String feeRange;
  final String state;
  final String ranking;
  final String studId;
  final String clgId;
  final VoidCallback? onCompareTap;
  final College clg;
  final double? width;
  CardStructure({
    Key? key,
    this.width,
    this.onCompareTap,
    required this.clg,
    required this.collegeID,
    required this.collegeName,
    required this.feeRange,
    required this.state,
    required this.ranking,
    required this.studId,
    required this.clgId,
    this.showTwoButtons = false,
    this.disableCardTap = false,
    this.onDetailTap,
  });

  @override
  State<CardStructure> createState() => _CardStructureState();

  static Future<bool> save(studId, clgId) async {
    Map<String, dynamic>? msg = await StudentService.addToFavorites(
      studentId: studId,
      collegeId: clgId,
    );
    return msg != null;
  }

  static Future<bool> remove(studId, clgId) async {
    bool msg = await StudentService.removeFromFavorites(studId, clgId);
    return msg;
  }
}

class _CardStructureState extends State<CardStructure> {
  final theme = ThemeController.to;
  int courseCount = 0;
  bool isSnackBarActive = false;
  bool isSnackBarActionClicked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCourseCount();
    });
  }

  void fetchCourseCount() async {
    List<Course> courses = await CollegeServices.getCoursesByCollege(
      widget.collegeID,
    );

    if (!mounted) return; // Prevent calling setState after dispose
    setState(() {
      courseCount = courses.length;
    });
  }

  var pfpController = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(saveController());

    return Obx(() {
      final CustomTheme themes = theme.currentTheme;

      return GestureDetector(
        onTap:
            widget.disableCardTap
                ? null
                : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CollegeDetail(
                            college: widget.clg,
                            collegeImage: widget.clg.image,
                            collegeName: widget.clg.name,
                            state: widget.clg.state,
                            lat: widget.clg.lat,
                            long: widget.clg.long,
                          ),
                    ),
                  );
                },
        child: Container(
          width: widget.width ?? 320,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Clr.cardClr,
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Image.network(widget.clg.image, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 4,
                    child: Obx(
                      () => InkWell(
                        onTap: () async {
                          if (pfpController.isGuestIn.value) {
                            if (isSnackBarActive)
                              return; // Prevent showing multiple snackbars

                            isSnackBarActive = true;
                            isSnackBarActionClicked = false;

                            final snackBar = SnackBar(
                              content: Text("Please Login First"),
                              duration: Duration(seconds: 3),
                              backgroundColor: themes.filterSelectedColor,
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'Login',
                                textColor: themes.filterTextColor,
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
                            if (controller.isSaved(widget.collegeID)) {
                              bool success = await CardStructure.remove(
                                widget.studId,
                                widget.clgId,
                              );
                              if (success) {
                                controller.toggleSave(widget.collegeID);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Removed from Shortlist",
                                      style: TextStyle(
                                        color: themes.filterTextColor,
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: themes.filterSelectedColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } else {
                              bool success = await CardStructure.save(
                                widget.studId,
                                widget.clgId,
                              );
                              if (success) {
                                controller.toggleSave(widget.collegeID);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Added To Shortlist",
                                      style: TextStyle(
                                        color: themes.filterTextColor,
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: themes.filterSelectedColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          padding: const EdgeInsets.all(6),

                          child: Center(
                            child: Icon(
                              controller.isSaved(widget.collegeID)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 27,
                              color: themes.saveIconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      child: Text(
                        widget.collegeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        4,
                        (index) =>
                            Icon(Icons.star, size: 18, color: themes.starColor),
                      )..add(
                        Icon(
                          Icons.star_half,
                          size: 18,
                          color: themes.starColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                          "Courses Offered",
                          "$courseCount  courses",
                          themes,
                        ),
                        _buildInfoColumn("Fee Range", widget.feeRange, themes),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.state,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          widget.ranking != "0" ? "#${widget.ranking} NIRF" : '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: themes.nirfTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    widget.showTwoButtons
                        ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: widget.onCompareTap,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: themes.filterSelectedColor,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text("Select to Compare"),
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: widget.onDetailTap,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themes.filterSelectedColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text("View Details"),
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoColumn(String title, String value, CustomTheme themes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: themes.courseCountColor,
          ),
        ),
      ],
    );
  }

  // ElevatedButton.icon(
  // icon: const Icon(
  // Icons.download,
  // size: 18,
  // color: Colors.white,
  // ),
  // label: const Text(
  // "Brochure",
  // style: TextStyle(fontSize: 18),
  // ),
  // style: ElevatedButton.styleFrom(
  // backgroundColor: themes.brochureBtnColor,
  // foregroundColor: Colors.white,
  // padding: const EdgeInsets.symmetric(horizontal: 16),
  // ),
  // onPressed: () {
  // // brochure action
  // },
  // )

}
