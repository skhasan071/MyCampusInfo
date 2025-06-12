import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BlogPageDetail extends StatelessWidget {
  final Map<String, dynamic> blog; // Blog data passed from the list page

  const BlogPageDetail({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Blog Detail',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to the blog list page
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "All Posts" link
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.filterSelectedColor,
                    side: BorderSide(color: theme.filterSelectedColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'All Posts',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.filterTextColor,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Category and reading time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blog['category'] ??
                          'Category', // Use a default value if category is null
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      blog['readingTime'] ??
                          '5 min read', // Default reading time
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Blog title and publish date
                Text(
                  blog['title'] ?? 'Blog title heading will go here',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Published on ${blog['publishedDate'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 16),

                // Blog Image Section
                Container(
                  color: Colors.grey[300],
                  height: 200,
                  child:
                      blog['image'] != null
                          ? Image.asset(blog['image']) // Load image from assets
                          : Image.asset(
                            'assets/default-image.jpg',
                          ), // Default image if none
                ),
                SizedBox(height: 16),

                // Content Sections
                for (var section in blog['content'])
                  buildContentSection(section),

                SizedBox(height: 20),

                // Contributors Section
                if (blog['contributors'] != null) ...[
                  Text(
                    'Contributors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      for (var contributor in blog['contributors'])
                        contributorCard(
                          contributor['name'],
                          contributor['title'],
                        ),
                    ],
                  ),
                ],

                // Static Subscribe Section
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Function to build each content section dynamically based on its type
  Widget buildContentSection(Map<String, dynamic> section) {
    switch (section['type']) {
      case 'bold':
        return Text(
          section['content']!,
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case 'scrollable':
        return SingleChildScrollView(child: Text(section['content']!));
      default:
        return Text(section['content']!);
    }
  }

  // Contributor Card Widget
  Widget contributorCard(String name, String title) {
    final theme = ThemeController.to.currentTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.selectedTextBackground,
            child: Icon(Icons.person, color: theme.filterSelectedColor),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
