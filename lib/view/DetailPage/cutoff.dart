import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Cutoff extends StatelessWidget {
  final String collegeId;
  final String collegeName;

  final String collegeImage;

  const Cutoff({
    super.key,
    required this.collegeId,
    required this.collegeName,
    required this.collegeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Cut-offs & Rankings",
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCollegeInfo(),
              const SizedBox(height: 16),
              Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 20),
              _buildRankingGrid(),
              const SizedBox(height: 20),
              Text(
                'Cut-off Trends',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildJeeTrendsCard(),
              const SizedBox(height: 16),
              _buildCategoryCutoffCard(),
              const SizedBox(height: 16),
              _buildBranchCutoffCard(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCollegeInfo() {
    return Row(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: Center(
            child: Image.network(
              collegeImage,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            collegeName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildRankingGrid() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "National & International Rankings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRankingItem("#15", "NIRF Ranking"),
              _buildRankingItem("#45", "QS World"),
              _buildRankingItem("#32", "Times Higher"),
              _buildRankingItem("A++", "NAAC Grade"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingItem(String rank, String label) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rank,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildJeeTrendsCard() {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "JEE Mains Cut-off Trends",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.filterSelectedColor,
              ),
            ),
            const SizedBox(height: 14),
            _buildCutoffBar("2025", 0.894, "89.4%"),
            _buildCutoffBar("2024", 0.921, "92.1%"),
            _buildCutoffBar("2023", 0.856, "85.6%"),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryCutoffCard() {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return _buildCard(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category-wise Cut-off 2025",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.filterSelectedColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildCutoffRow("General", "89.4%"),
            _buildCutoffRow("OBC", "84.2%"),
            _buildCutoffRow("SC", "78.6%"),
            _buildCutoffRow("ST", "75.1%"),
          ],
        ),
      );
    });
  }

  Widget _buildBranchCutoffCard() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Branch-wise Cut-off 2025",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildBranchCard("Computer Science Engineering", "95.4%", "90.2%"),
          _buildBranchCard("Mechanical Engineering", "88.7%", "84.5%"),
          _buildBranchCard("Electrical Engineering", "86.9%", "82.3%"),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCutoffBar(String year, double value, String label) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(width: 48, child: Text(year)),
            Expanded(
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                color: theme.filterSelectedColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    });
  }

  Widget _buildCutoffRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBranchCard(String title, String general, String obc) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              "General: $general | OBC: $obc",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    });
  }
}
