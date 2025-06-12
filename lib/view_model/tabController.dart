import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CollegeTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentIndex = 0.obs;

  final List<String> tabs = [
    "Overview",
    "Courses",
    "Reviews",
    "Placements",
    "Admission & Eligibility",
    "Cost & Location",
    "Scholarship & Aid",
    "Distance from Hometown",
    "Latest News & Insights",
    "Q & A",
    "Hostel & Campus Life",
    "Cut-offs & Ranking",
  ];

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
