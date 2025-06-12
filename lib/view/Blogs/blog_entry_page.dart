import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminBlogEntryPage extends StatefulWidget {
  const AdminBlogEntryPage({super.key});

  @override
  _AdminBlogEntryPageState createState() => _AdminBlogEntryPageState();
}

class _AdminBlogEntryPageState extends State<AdminBlogEntryPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> contentSections = [];
  List<Map<String, String>> contributors = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController readingTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController contributorNameController = TextEditingController();
  final TextEditingController contributorTitleController = TextEditingController();
  String contentType = 'regular';
  // 'regular', 'bold', or 'scrollable'
  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    readingTimeController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    contributorNameController.dispose();
    contributorTitleController.dispose();
    super.dispose();
  }
  void addContentSection() {
    setState(() {
      contentSections.add({
        'type': contentType,
        'content': contentController.text,
      });
    });
    contentController.clear();  // Clear the text input after adding
  }

  void addContributor() {
    setState(() {
      contributors.add({
        'name': contributorNameController.text,
        'title': contributorTitleController.text,
      });
    });
    contributorNameController.clear();
    contributorTitleController.clear();  // Clear the text inputs for contributors
  }

  // Function to submit the blog data to the backend
  Future<void> submitBlog() async {
    if (_formKey.currentState!.validate()) {
      final blogData = {
        'title': titleController.text,
        'category': categoryController.text,
        'readingTime': readingTimeController.text,
        'description': descriptionController.text,
        'content': contentSections,  // List of content sections (bold, scrollable, etc.)
        'contributors': contributors,  // List of contributors
      };

      final response = await http.post(
        Uri.parse('https://tc-ca-server.onrender.com/api/colleges/add/Blogs'),  // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(blogData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blog added successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add blog')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Blog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blog Title Input
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Blog Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                // Category Input
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the category';
                    }
                    return null;
                  },
                ),
                // Reading Time Input
                TextFormField(
                  controller: readingTimeController,
                  decoration: InputDecoration(labelText: 'Reading Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter reading time';
                    }
                    return null;
                  },
                ),
                // Description Input
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Content Type Selector (bold, scrollable, or regular)
                DropdownButton<String>(
                  value: contentType,
                  onChanged: (String? newValue) {
                    setState(() {
                      contentType = newValue!;
                    });
                  },
                  items: <String>['regular', 'bold', 'scrollable']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // Content Text Input
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Add Content Section Button
                ElevatedButton(
                  onPressed: addContentSection,
                  child: Text('Add Content Section'),
                ),

                SizedBox(height: 20),

                // Display Added Content Sections
                Text(
                  'Added Content Sections',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                for (var section in contentSections)
                  buildContentSection(section),  // Display each content section dynamically

                SizedBox(height: 20),

                // Contributors Section
                Text(
                  'Add Contributors',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: contributorNameController,
                  decoration: InputDecoration(labelText: 'Contributor Name'),
                ),
                TextFormField(
                  controller: contributorTitleController,
                  decoration: InputDecoration(labelText: 'Contributor Title'),
                ),
                ElevatedButton(
                  onPressed: addContributor,
                  child: Text('Add Contributor'),
                ),

                // Display Added Contributors
                SizedBox(height: 16),
                for (var contributor in contributors)
                  contributorCard(contributor['name']!, contributor['title']!),

                SizedBox(height: 20),

                // Submit Blog Button
                ElevatedButton(
                  onPressed: submitBlog,
                  child: Text('Submit Blog'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build content section based on its type
  Widget buildContentSection(Map<String, String> section) {
    switch (section['type']) {
      case 'bold':
        return Text(
          section['content']!,
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case 'scrollable':
        return SingleChildScrollView(
          child: Text(section['content']!),
        );
      default:
        return Text(section['content']!);
    }
  }

  // Contributor Card Widget
  Widget contributorCard(String name, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.black),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
