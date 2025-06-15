import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  String selectedCategory = 'All News';

  final List<String> categories = [
    'All News',
    'Academic',
    'Campus Life',
    'Research',
    'Events',
  ];

  final List<Map<String, dynamic>> allNews = [
    {
      'category': 'Academic',
      'title': 'Student Achievement Awards 2025',
      'summary':
          'Annual ceremony celebrating outstanding academic and extracurricular achievements...',
      'author': 'Prof. Sarah Wilson',
      'date': 'Mar 10, 2025',
    },
    {
      'category': 'Research',
      'title': 'Breakthrough in Quantum Computing Research',
      'summary':
          'College researchers make significant progress in quantum computing...',
      'author': 'Dr. John Smith',
      'date': 'Mar 8, 2025',
    },
    {
      'category': 'Events',
      'title': 'Breakthrough in Quantum Computing Research',
      'summary':
          'College researchers make significant progress in quantum computing...',
      'author': 'Dr. John Smith',
      'date': 'Mar 8, 2025',
    },
    {
      'category': 'Campus Life',
      'title': 'Breakthrough in Quantum Computing Research',
      'summary':
          'College researchers make significant progress in quantum computing...',
      'author': 'Dr. John Smith',
      'date': 'Mar 8, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNews =
        selectedCategory == 'All News'
            ? allNews
            : allNews
                .where((item) => item['category'] == selectedCategory)
                .toList();

    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Latest News & Insights',
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

        body: Container(
          decoration: BoxDecoration(gradient: theme.backgroundGradient),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topNewsCard(),
                const SizedBox(height: 16),
                _buildCategoryChips(),
                const SizedBox(height: 16),
                ...filteredNews.map((item) => _newsCard(item)).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }
  final theme = ThemeController.to.currentTheme;
  Widget _topNewsCard() {
    return Container(
      height: 160,
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
          gradient: theme.backgroundGradient
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'New Research Center Opening Ceremony',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'March 15, 2025',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category;

            return ChoiceChip(
              label: Text(category, style: TextStyle(fontSize: 16)),
              selected: isSelected,
              selectedColor: theme.filterSelectedColor,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              checkmarkColor: Colors.white,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
              },
            );
          },
        ),
      );
    });
  }

  Widget _newsCard(Map<String, dynamic> item) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(height: 120, color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.filterSelectedColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(
                                0,
                                4,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          item['category'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.filterTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['summary'],
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['author'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        item['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
