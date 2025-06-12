import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'blog_detail_page.dart'; // Import the detail page

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Map<String, dynamic>> blogs = [];

  // Fetch blogs from the backend
  Future<void> fetchBlogs() async {
    final response = await http.get(
      Uri.parse('https://tc-ca-server.onrender.com/api/colleges/get/Blogs'),
    ); // Change to your backend URL

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        blogs = List<Map<String, dynamic>>.from(responseData['blogs']);
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs(); // Fetch blogs when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Describe what your blog is about" Heading
                  Text(
                    'Blogs',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore Latest Blogs',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // "Featured blog posts" Heading
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: theme.backgroundGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Featured blog posts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // List of blog cards
                        blogs.isEmpty
                            ? Center(
                              child: CircularProgressIndicator(
                                color: theme.filterSelectedColor,
                              ),
                            ) // Show loading indicator while fetching
                            : ListView.builder(
                              itemCount: blogs.length,
                              itemBuilder: (context, index) {
                                return BlogCard(
                                  title: blogs[index]['title'],
                                  category: blogs[index]['category'],
                                  readingTime: blogs[index]['readingTime'],
                                  description: blogs[index]['description'],
                                  image:
                                      blogs[index]['image'] ??
                                      'assets/default-image.jpg', // Use default image if none
                                  blog:
                                      blogs[index], // Pass the entire blog to the detail page
                                );
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class BlogCard extends StatelessWidget {
  final String title;
  final String category;
  final String readingTime;
  final String description;
  final String image;
  final Map<String, dynamic> blog;

  const BlogCard({
    super.key,
    required this.title,
    required this.category,
    required this.readingTime,
    required this.description,
    required this.image,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog image
              Image.asset(image), // Replace with your image assets or URLs

              SizedBox(height: 16),

              // Category and reading time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category, style: TextStyle(color: Colors.grey)),
                  Text(readingTime, style: TextStyle(color: Colors.black)),
                ],
              ),

              SizedBox(height: 16),

              // Blog title
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Blog description
              Text(description, style: TextStyle(color: Colors.grey)),

              SizedBox(height: 16),

              // Read more button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogPageDetail(blog: blog),
                    ),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ), // removes ripple highlight on press
                  elevation: MaterialStateProperty.all(0),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Read more',
                      style: TextStyle(color: theme.filterSelectedColor),
                    ),
                    Icon(Icons.arrow_forward, color: theme.filterSelectedColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
