import 'package:intl/intl.dart';
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
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.filterSelectedColor,
                    side: BorderSide(color: theme.filterSelectedColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    blog['category'],
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.filterTextColor,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Blog title and publish date
                Text(
                  blog['title'] ?? 'Blog title heading will go here',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Published on ${DateFormat('dd-MM-yyyy').format(DateTime.parse(blog['publishedDate'].toString()).toLocal()) ?? 'N/A'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                SizedBox(height: 16),

                // Blog Image Section
                blog['image'] != '--'
                 ? Container(
                  color: Colors.grey[300],
                  height: 200,
                  child: Image.network(blog['image'], fit: BoxFit.cover,),
                ) : SizedBox.shrink() ,
                SizedBox(height: blog['image'] == '--' ? 0 : 16),

                // Content Sections
                for (var section in blog['content'])
                  buildContentSection(section),

                SizedBox(height: 20),

                // Contributors Section
                if (blog['contributors'].isNotEmpty) ...[
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.selectedTextBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.selectedTextBackground, width: 2),
            ),
            child: Center(
              child: Text(name[0], style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),),
            ),
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
