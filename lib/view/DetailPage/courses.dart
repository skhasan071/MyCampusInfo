import 'package:my_campus_info/services/college_services.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:my_campus_info/model/course.dart';
import 'package:get/get.dart';

class Courses extends StatefulWidget {
  final String uid;
  final String collegeImage;
  final String collegeName;

  const Courses(
      this.uid, {
        super.key,
        required this.collegeImage,
        required this.collegeName,
      });

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> with TickerProviderStateMixin {
  List<Course> main_courses = [];
  Map<String, List<Course>> categorizedCourses = {};
  bool isLoading = true;
  late TabController _tabController;

  final categoryMap = {
    'All Courses': 'All Courses',
    'Engineering': 'Engineering',
    'Medical': 'Medical',
    'Management': 'Management',
    'Arts': 'Arts',
  };

  List<String> activeTabs = [];

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  void getCourse() async {
    setState(() => isLoading = true);

    main_courses = await CollegeServices.getCoursesByCollege(widget.uid);

    categorizedCourses['All Courses'] = main_courses;
    categorizedCourses['Engineering'] =
        main_courses.where((c) => c.category == 'Engineering').toList();
    categorizedCourses['Medical'] =
        main_courses.where((c) => c.category == 'Medical').toList();
    categorizedCourses['Management'] =
        main_courses.where((c) => c.category == 'Management').toList();
    categorizedCourses['Arts'] =
        main_courses.where((c) => c.category == 'Arts').toList();

    activeTabs = categoryMap.keys
        .where((category) => categorizedCourses[category]?.isNotEmpty ?? false)
        .toList();

    print(activeTabs.length);

    _tabController = TabController(length: activeTabs.length, vsync: this);

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return DefaultTabController(
        length: activeTabs.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Courses & Fees',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCollegeLogo(),
              const SizedBox(height: 10),
              isLoading
                  ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),)
                  : Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: TabBar(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      controller: _tabController,
                      isScrollable: activeTabs.length > 3,
                      tabAlignment: activeTabs.length > 3 ? TabAlignment.start : TabAlignment.fill,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      indicator: BoxDecoration(
                        color: theme.filterSelectedColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: activeTabs.map((title) => Tab(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(title),
                      ),),).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: TabBarView(
                      controller: _tabController,
                      children: activeTabs.map((category) {
                        List<Course> courses =
                            categorizedCourses[category] ?? [];
                        return courses.isEmpty
                            ? const Center(
                          child: Text(
                            "No Course Offered",
                            style: TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        )
                            : ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 16),
                              child: _buildCourseCard(
                                courseName: course.courseName,
                                duration: course.duration,
                                fees: '${course.fees}Rs',
                                eligibility: course.examType,
                                intake: course.maxRankOrPercentile.toString(),
                                RankPer:course.rankType,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCollegeLogo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Center(
              child: Image.network(
                widget.collegeImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.collegeName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required String courseName,
    required String duration,
    required String fees,
    required String eligibility,
    required String intake,
    required String RankPer,
  }) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      print(courseName + '<------------->');
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: theme.backgroundGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(duration, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCourseDetail('Annual Fees', fees),
            _buildCourseDetail('Eligibility', eligibility),
            _buildCourseDetail(RankPer, intake),
            // const SizedBox(height: 12),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: theme.filterSelectedColor,
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.zero,
            //       ),
            //     ),
            //     onPressed: () {},
            //     child: const Text(
            //       'Apply Now',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  Widget _buildCourseDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
