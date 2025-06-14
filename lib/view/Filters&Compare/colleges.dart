import 'package:my_campus_info/constants/colors.dart';
import 'package:my_campus_info/constants/filter.dart';
import 'package:my_campus_info/constants/ui_helper.dart';
import 'package:my_campus_info/constants/card.dart';
import 'package:my_campus_info/model/college.dart';
import 'package:my_campus_info/services/college_services.dart';
import 'package:my_campus_info/view/profiles/choice_preferences.dart';
import 'package:my_campus_info/view_model/controller.dart';
import 'package:my_campus_info/view_model/data_loader.dart';
import 'package:my_campus_info/view_model/filterController.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:my_campus_info/view_model/saveController.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/user_services.dart';
import '../DetailPage/collegeDetail.dart';

class Colleges extends StatefulWidget {
  const Colleges({super.key});

  @override
  State<Colleges> createState() => _CollegesState();
}

class _CollegesState extends State<Colleges> {
  var controller = Get.put(Controller());
  var saveCtrl = Get.put(saveController());
  var profile = Get.put(ProfileController());
  var filter = Get.put(FilterController());
  var loader = Get.put(Loader());
  List<College> colleges = [];
  List<College> states = [];
  List<College> cities = [];
  List<College> rankings = [];
  List<College> privates = [];
  Map<String, String?> selectedStreamsBySection = {};

  @override
  void initState() {
    super.initState();
    getColleges();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Obx(
            () =>
                !loader.isLoading.value
                    ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Text(
                                "Hello, ${profile.profile.value == null ? "Guest" : profile.profile.value!.name}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            !controller.isGuestIn.value
                                ? rankings.isNotEmpty
                                    ? _buildSection(
                                      "Colleges Based on NIRF",
                                      rankings,
                                    )
                                    : Container()
                                : Container(),

                            _buildBox(
                              title: "Explore College as per your preference.",
                              buttonText: "Edit Preferences",
                              pageNo: 0,
                              callback: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CoursePreferencesPage(
                                          isFlow: false,
                                        ),
                                  ),
                                );
                              },
                            ),

                            states.isNotEmpty
                                ? _buildSection(
                                  "Colleges Based on State",
                                  states,
                                )
                                : Container(),

                            _buildBox(
                              title: "Which colleges match your preferences?",
                              buttonText: "Predict My College",
                              pageNo: 3,
                            ),

                            cities.isNotEmpty
                                ? _buildSection(
                                  "Colleges Based on City",
                                  cities,
                                )
                                : Container(),

                            _buildBox(
                              title: "Want the latest insights on colleges?",
                              buttonText: "Read Insights",
                              pageNo: 2,
                            ),

                            controller.isLoggedIn.value && privates.isNotEmpty
                                ? _buildSection(
                                  "Popular Private Colleges",
                                  privates,
                                )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                    : Center(
                      child: CircularProgressIndicator(
                        color: theme.filterSelectedColor,
                      ),
                    ),
          ),
        ),
      );
    });
  }

  Widget _buildSection(String title, List<College> data) {
    List<College> getFilteredColleges() {
      final sectionSelectedStream = selectedStreamsBySection[title];

      if (sectionSelectedStream == null || sectionSelectedStream.isEmpty) {
        return data;
      }

      return data.where((college) {
        return college.stream == sectionSelectedStream;
      }).toList();
    }

    final ScrollController scrollController = ScrollController();

    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
              gradient: theme.backgroundGradient,
              boxShadow: theme.boxShadow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 50,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final filterTitle =
                            isAll
                                ? 'All'
                                : profile.interestedStreams[index - 1];

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Filter(
                              title: filterTitle,
                              section: title,
                              onStreamSelected: (stream) {
                                setState(() {
                                  if (stream == 'All') {
                                    selectedStreamsBySection.remove(title);
                                  } else {
                                    selectedStreamsBySection[title] = stream;
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        );
                      },
                      itemCount: profile.interestedStreams.length + 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Cards
                SizedBox(
                  height: 390,
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: getFilteredColleges().length,
                    itemBuilder:
                        (context, index) => GestureDetector(
                          onTap: () async {
                            await Future.delayed(Duration(seconds: 5));

                            // Navigate to CollegeDetail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CollegeDetail(
                                      college: getFilteredColleges()[index],
                                      collegeName:
                                          getFilteredColleges()[index].name,
                                      lat: getFilteredColleges()[index].lat,
                                      long: getFilteredColleges()[index].long,
                                      state: getFilteredColleges()[index].state,
                                      collegeImage:
                                          getFilteredColleges()[index].image,
                                    ),
                              ),
                            );
                          },
                          child: CardStructure(
                            collegeID: getFilteredColleges()[index].id,
                            collegeName: getFilteredColleges()[index].name,
                            feeRange: getFilteredColleges()[index].feeRange,
                            state: getFilteredColleges()[index].state,
                            ranking:
                                getFilteredColleges()[index].ranking.toString(),
                            studId:
                                !controller.isGuestIn.value
                                    ? profile.profile.value!.id
                                    : "Nothing",
                            clgId: getFilteredColleges()[index].id,
                            clg: getFilteredColleges()[index],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Arrows (outside the container)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  side: BorderSide(color: theme.filterSelectedColor),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ).copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset - 300,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: theme.filterSelectedColor,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  side: BorderSide(color: theme.filterSelectedColor),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ).copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset + 300,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: theme.filterSelectedColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildBox({
    required String title,
    required String buttonText,
    required int pageNo,
    VoidCallback? callback,
  }) {
    final theme = ThemeController.to.currentTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: theme.boxGradient,
              border: Border.all(color: Clr.primaryBtnClr),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                UiHelper.getPrimaryBtn(
                  title: buttonText,
                  callback:
                      callback ??
                      () {
                        controller.navSelectedIndex.value = pageNo;
                      },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getFavorites() async {
    // Check if profile is null before accessing id
    if (profile.profile.value != null) {
      List<College> colleges = await StudentService.getFavoriteColleges(
        profile.profile.value!.id,
      );
      for (College college in colleges) {
        saveCtrl.savedColleges.add(college.id);
      }
    } else {
      // Handle case when profile is null (e.g., show a message or return early)
      return;
    }
  }

  Future<void> getColleges() async {
    loader.isLoading.value = true;

    if (controller.isLoggedIn.value) {
      rankings = await StudentService.getCollegesByRanking(
        profile.profile.value!.id,
      );
      privates = await StudentService.getPrivateCollegesByInterest(
        profile.profile.value!.id,
      );
      states = await CollegeServices.fetchFilteredColleges(
        streams: profile.profile.value!.interestedStreams!,
        state: profile.profile.value!.state,
      );
      cities = await CollegeServices.fetchFilteredColleges(
        streams: profile.profile.value!.interestedStreams!,
        city: profile.profile.value!.city,
      );
    } else {
      states = await CollegeServices.fetchFilteredColleges(
        streams: profile.interestedStreams,
        state: "Maharashtra",
      );
      cities = await CollegeServices.fetchFilteredColleges(
        streams: profile.interestedStreams,
        city: "Mumbai",
      );
    }

    loader.isLoading.value = false;
  }
}
