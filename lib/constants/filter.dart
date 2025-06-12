import 'package:my_campus_info/view_model/filterController.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Filter extends StatelessWidget {
  final String title;
  final String section; // For section
  final VoidCallback? onTap;
  final Function(String) onStreamSelected; // New callback for stream selection

  const Filter({
    super.key,
    required this.title,
    required this.section,
    this.onTap,
    required this.onStreamSelected, // Pass the callback
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilterController>();

    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      final bool selected = controller.isSelected(section, title);

      return GestureDetector(
        onTap: () {
          controller.selectFilterForSection(section, title);
          onStreamSelected(title); // Pass selected stream here
          if (onTap != null) onTap!();
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: selected ? theme.filterSelectedColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.filterSelectedColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: TextStyle(
              color: selected ? theme.filterTextColor : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
