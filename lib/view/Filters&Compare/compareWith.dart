import 'package:my_campus_info/constants/card.dart';
import 'package:my_campus_info/services/user_services.dart';
import 'package:my_campus_info/view/DetailPage/collegeDetail.dart';
import 'package:my_campus_info/view/Filters&Compare/compareCollege.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:my_campus_info/constants/colors.dart';
import 'package:my_campus_info/model/college.dart';
import 'package:get/get.dart';
import 'package:my_campus_info/services/college_services.dart';

class CompareWith extends StatefulWidget {
  final College clg;
  final String collegeId;

  const CompareWith({super.key, required this.clg, required this.collegeId});

  @override
  State<CompareWith> createState() => _CompareWithState();
}

class _CompareWithState extends State<CompareWith> {
  bool showShortlistedOnly = false;

  List<College> colleges = [];
  List<College> allColleges = [];
  List<College> filteredColleges = [];

  var profile = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    getColleges();
    fetchAllColleges();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Choose College',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Compare. Decide. Succeed.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text(
                  "Compare With",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.filterSelectedColor,
                    fontSize: 33,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  "Select From Shortlisted Colleges or\nSearch Other",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Clr.primaryBtnClr,
                  ),
                ),

                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.filterSelectedColor),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: Clr.primaryBtnClr,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                cursorColor: theme.filterSelectedColor,
                                decoration: const InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(fontSize: 13),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    filteredColleges =
                                        allColleges.where((college) {
                                          final nameMatch = college.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase());
                                          final stateMatch = college.country
                                              .toLowerCase()
                                              .contains(value.toLowerCase());
                                          return nameMatch || stateMatch;
                                        }).toList();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showShortlistedOnly = !showShortlistedOnly;
                          filteredColleges =
                              showShortlistedOnly
                                  ? List.from(colleges)
                                  : List.from(allColleges);
                        });
                      },
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.filterSelectedColor),
                          color:
                              showShortlistedOnly
                                  ? theme.filterSelectedColor
                                  : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color:
                                  showShortlistedOnly
                                      ? theme.filterTextColor
                                      : Clr.primaryBtnClr,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              showShortlistedOnly
                                  ? "Showing Shortlisted Colleges"
                                  : "Shortlisted Colleges",
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    showShortlistedOnly
                                        ? theme.filterTextColor
                                        : Colors.black,
                                fontWeight:
                                    showShortlistedOnly
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: theme.filterSelectedColor,
                      ),
                    )
                    : filteredColleges.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Text(
                          showShortlistedOnly
                              ? "No colleges shortlisted"
                              : "No colleges found",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemBuilder: (context, index) {
                        College clg = filteredColleges[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CardStructure(
                            width: double.infinity,
                            collegeID: clg.id,
                            collegeName: clg.name,
                            feeRange: clg.feeRange,
                            state: clg.country,
                            ranking: clg.ranking.toString(),
                            studId: profile.profile.value!.id,
                            clgId: clg.id,
                            clg: clg,
                            showTwoButtons: true,
                            disableCardTap: true,
                            onDetailTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CollegeDetail(
                                        college: clg,
                                        collegeImage: clg.image,
                                        collegeName: clg.name,
                                        state: clg.state,
                                        lat: clg.lat,
                                        long: clg.long,
                                      ),
                                ),
                              );
                            },
                            onCompareTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CompareColleges(
                                        college: clg,
                                        clg: clg,
                                        collegeId: clg.id,
                                        collegeName: clg.name,
                                        collegeImage: clg.image,
                                        ranking: clg.ranking.toString(),
                                        feeRange: clg.feeRange,
                                        state: clg.state,
                                        firstCollege: widget.clg,
                                        secondCollege: clg,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      itemCount: filteredColleges.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> getColleges() async {
    colleges = await StudentService.getFavoriteColleges(
      profile.profile.value!.id,
    );

    if (showShortlistedOnly) {
      filteredColleges = List.from(colleges);
    }

    setState(() {});
  }

  Future<void> fetchAllColleges() async {
    setState(() => isLoading = true);

    allColleges = await CollegeServices.getColleges();
    filteredColleges = List.from(allColleges);

    setState(() => isLoading = false);
  }
}
