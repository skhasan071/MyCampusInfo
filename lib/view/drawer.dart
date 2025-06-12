import 'package:my_campus_info/view/Setting&Support/settting.dart';
import 'package:my_campus_info/view/Setting&Support/support.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../services/shortListCollegeController.dart';
import '../view_model/controller.dart';
import 'SignUpLogin/login.dart';

class DrawerWidget extends StatelessWidget {
  var controller = Get.put(Controller());
  var pfpController = Get.put(ProfileController());
  GlobalKey<ScaffoldState> scaffoldKey;
  final int shortlistedCollegesCount;
  final ShortlistedCollegesController shortlistedCollegesController =
      Get.find();
  DrawerWidget(this.scaffoldKey, this.shortlistedCollegesCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Drawer(
        child: Container(
          decoration: BoxDecoration(gradient: theme.backgroundGradient),
          child: SafeArea(
            child: Column(
              children: [
                // Top Section with Logo, Search, and Avatar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Logo',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cursive',
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        cursorColor: theme.filterSelectedColor,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),

                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.filterSelectedColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Menu List
                Expanded(
                  child: ListView(
                    children: [
                      _buildTile(
                        Icons.home,
                        'Home',
                        callback: () {
                          controller.navSelectedIndex.value = 0;
                          scaffoldKey.currentState?.closeDrawer();
                        },
                      ),
                      _buildTile(
                        Icons.favorite_border,
                        'Shortlist/Favorites',
                        trailing: _badge(
                          controller.isGuestIn.value
                              ? "Login First"
                              : shortlistedCollegesController
                                  .shortlistedCollegesCount
                                  .value
                                  .toString(),
                        ),
                        callback: () {
                          if (controller.isGuestIn.value) {
                            scaffoldKey.currentState?.closeDrawer();

                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please Login First",
                                    style: TextStyle(
                                      color: theme.filterTextColor,
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: theme.filterSelectedColor,
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'Login',
                                    textColor: theme.filterTextColor,
                                    onPressed: () {
                                      // Use GetX navigation
                                      Get.back(); // Closes snackbar or drawer if open
                                      Get.off(
                                        () => LoginPage(),
                                      ); // Navigate and remove current screen
                                    },
                                  ),
                                ),
                              );
                            });
                          } else {
                            controller.navSelectedIndex.value = 4;
                            scaffoldKey.currentState?.closeDrawer();
                          }
                        },
                      ),
                      // ExpansionTile(
                      //   leading: Icon(
                      //     Icons.account_balance,
                      //     color: Colors.black,
                      //   ),
                      //   iconColor: Colors.black,
                      //   title: Text(
                      //     'Management Colleges',
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      //   children: [
                      //     _buildSubTile(
                      //       Icons.star,
                      //       'Top Ranked Colleges',
                      //       () {},
                      //     ),
                      //     _buildSubTile(
                      //       Icons.school,
                      //       'Find Colleges by Specialization',
                      //       () {},
                      //     ),
                      //     _buildSubTile(
                      //       Icons.info_outline,
                      //       'All about Management',
                      //       () {},
                      //     ),
                      //   ],
                      // ),
                      _buildTile(
                        Icons.insights,
                        'Insights',
                        callback: () {
                          controller.navSelectedIndex.value = 2;
                          scaffoldKey.currentState?.closeDrawer();
                        },
                      ),
                      Divider(),
                      _buildTile(
                        Icons.support_agent,
                        'Support',
                        callback: () {
                          Get.to(() => SupportPage());
                        },
                      ),
                      _buildTile(
                        Icons.settings,
                        'Settings',
                        callback: () {
                          Get.to(() => SettingsPage());
                        },
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Bottom User Info
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    controller.isGuestIn.value
                        ? 'Please Login'
                        : pfpController.profile.value!.name!,
                  ),
                  subtitle: Text(
                    controller.isGuestIn.value
                        ? 'Login to explore more features'
                        : pfpController.profile.value!.email!,
                  ),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    if (controller.isGuestIn.value) {
                      scaffoldKey.currentState?.closeDrawer();

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                                // Use GetX navigation
                                Get.back(); // Closes snackbar or drawer if open
                                Get.off(
                                  () => LoginPage(),
                                ); // Navigate and remove current screen
                              },
                            ),
                          ),
                        );
                      });
                    } else {
                      controller.navSelectedIndex.value = 5;
                      scaffoldKey.currentState?.closeDrawer();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? callback,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      trailing: trailing,
      onTap: callback,
    );
  }

  Widget _badge(String count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(count, style: TextStyle(fontSize: 12, color: Colors.white)),
    );
  }
}
