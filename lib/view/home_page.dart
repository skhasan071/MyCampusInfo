import 'package:my_campus_info/constants/ui_helper.dart';
import 'package:my_campus_info/model/user.dart';
import 'package:my_campus_info/services/user_services.dart';
import 'package:my_campus_info/view/Blogs/blog_page.dart';
import 'package:my_campus_info/view/SignUpLogin/login.dart';
import 'package:my_campus_info/view/college_predictor_page.dart';
import 'package:my_campus_info/view/Filters&Compare/colleges.dart';
import 'package:my_campus_info/view/drawer.dart';
import 'package:my_campus_info/view/predicted_college.dart';
import 'package:my_campus_info/view/profiles/profile_page.dart';
import 'package:my_campus_info/view/Filters&Compare/searchPage.dart';
import 'package:my_campus_info/view/Filters&Compare/shortlistCollegePage.dart';
import 'package:my_campus_info/view_model/network_controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/controller.dart';
import '../view_model/profile_controller.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage(this.token, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = Get.put(Controller());
  var profileController = Get.put(ProfileController());
  var networkController = Get.find<NetworkController>();
  bool isSnackBarActive = false;
  bool isSnackBarActionClicked = false;

  List<Widget> screens = [
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Colleges(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SelectionPage(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: BlogPage(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CollegePredictorPage(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ShortlistedCollegesPage(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ProfilePage(),
    ),
    SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CollegeResultsPage(),
    ),
  ];
  int shortlistedCollegesCount = 0; // Variable to hold the count
  @override
  void initState() {
    super.initState();
    widget.token != "" ? getUser() : controller.isGuestIn(true);
  }

  void updateShortlistedCount(int count) {
    setState(() {
      shortlistedCollegesCount = count;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return WillPopScope(
        onWillPop: () async {
          if (controller.navSelectedIndex.value == 0) {
            bool? shouldExit = await showDialog<bool>(
              context: context,
              builder:
                  (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: theme.backgroundGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Exit",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Are you sure you want to exit?",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: theme.filterSelectedColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.filterSelectedColor,
                                  foregroundColor: theme.filterTextColor,
                                  side: BorderSide(
                                    color: theme.filterSelectedColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("Yes"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            );
            return shouldExit ?? false;
          } else {
            controller.navSelectedIndex.value = 0;
            return false;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: getAppBar(),
          body: Obx(() {
            if(!networkController.isConnected.value){
              return Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No Internet Connection',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ), textAlign:  TextAlign.center,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                    backgroundColor: theme.brochureBtnColor,
                  ), child: Text('Refresh', style: TextStyle(color: Colors.white,),))
              ],
            ),);}

            if(!controller.isLoggedIn.value && !controller.isGuestIn.value){
              return Center(child: CircularProgressIndicator(color: Colors.black,),);
            }

            return screens[controller.navSelectedIndex.value];

          }),
          drawer: DrawerWidget(scaffoldKey, shortlistedCollegesCount),
          bottomNavigationBar: getBottomNavBar(),  // Ensure this is outside any conditional check
        )
      );
    });
  }

  PreferredSizeWidget getAppBar() {
    final theme = ThemeController.to.currentTheme;
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      icon: Icon(Icons.menu, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "MyCampusInfo",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.navSelectedIndex.value = 1;
                      },
                      child: Icon(Icons.search, color: Colors.black, size: 28,),
                    ),
                    SizedBox(width: 12,),
                    GestureDetector(
                      onTap: () {
                        if (controller.isGuestIn.value) {
                          if (isSnackBarActive)
                            return; // Prevent showing multiple snackbars

                          isSnackBarActive = true;
                          isSnackBarActionClicked = false;

                          final snackBar = SnackBar(
                            content: Text(
                              "Please Login First",
                              style: TextStyle(color: theme.filterTextColor),
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: theme.filterSelectedColor,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Login',
                              textColor: theme.filterTextColor,
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
                          controller.navSelectedIndex.value = 5;
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            controller.isGuestIn.value ? "?" : "P",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomNavBar() {
    final theme = ThemeController.to.currentTheme;
    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UiHelper.getNavItem(
              label: "Home",
              icon: Icons.home_outlined,
              callback: () {
                controller.navSelectedIndex.value = 0;
              },
              selected: controller.navSelectedIndex.value == 0,
            ),
            UiHelper.getNavItem(
              label: "Search",
              icon: Icons.search,
              callback: () {
                controller.navSelectedIndex.value = 1;
              },
              selected: controller.navSelectedIndex.value == 1,
            ),
            UiHelper.getNavItem(
              label: "Insights",
              icon: Icons.insights,
              callback: () {
                controller.navSelectedIndex.value = 2;
              },
              selected: controller.navSelectedIndex.value == 2,
            ),
            UiHelper.getNavItem(
              label: "Services",
              icon: Icons.design_services,
              callback: () {
                controller.navSelectedIndex.value = 3;
              },
              selected: controller.navSelectedIndex.value == 3,
            ),
            UiHelper.getNavItem(
              label: "Shortlist",
              icon: Icons.list,
              callback: () {
                if (controller.isGuestIn.value) {
                  if (isSnackBarActive)
                    return; // Prevent showing multiple snackbars

                  isSnackBarActive = true;
                  isSnackBarActionClicked = false;
                  final snackBar = SnackBar(
                    content: Text(
                      "Please Login First",
                      style: TextStyle(color: theme.filterTextColor),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: theme.filterSelectedColor,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Login',
                      textColor: theme.filterTextColor,
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
                  controller.navSelectedIndex.value = 4;
                }
              },
              selected: controller.navSelectedIndex.value == 4,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUser() async {
    Student? student = await StudentService().getStudent(widget.token);
    profileController.profile.value = student;
    profileController.interestedStreams.value = student!.interestedStreams!;
    profileController.coursesInterested.value = student.coursesInterested!;
    controller.isLoggedIn.value = true;
  }

}
