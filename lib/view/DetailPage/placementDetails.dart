import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_campus_info/model/placement.dart';

class PlacementDetails extends StatefulWidget {
  final String collegeId;
  const PlacementDetails({super.key, required this.collegeId});

  @override
  State<PlacementDetails> createState() => _PlacementDetailsState();
}

class _PlacementDetailsState extends State<PlacementDetails> {
  late Placement placementData;
  bool isLoading = true; // Loading state for the page
  String errorMessage = ""; // To show an error message if data isn't found

  @override
  void initState() {
    super.initState();
    fetchPlacementData();
  }

  Future<void> fetchPlacementData() async {
    final url =
        'https://tc-ca-server.onrender.com/api/colleges/placement/${widget.collegeId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the data exists and assign it to placementData
      if (data.isNotEmpty) {
        setState(() {
          placementData = Placement.fromJson(
            data[0],
          ); // Assuming the response is an array and we take the first item
          isLoading = false; // Stop showing loader
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              "No placement data available for this college."; // Set error message if no data
        });
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage =
            "Error fetching placement data."; // Set error message if there is an API error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to.currentTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Placement Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [Padding(padding: EdgeInsets.only(right: 12))],
        backgroundColor: Colors.white,
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: theme.filterSelectedColor,
                ),
              ) // Show loader while loading data
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorMessage
                        .isNotEmpty) // If error message exists, show it
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    if (errorMessage.isEmpty) ...[
                      Obx(() {
                        final theme = ThemeController.to.currentTheme;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double horizontalSpacing = 8;
                            double totalHorizontalPadding = 6 * 2;
                            double availableWidth =
                                constraints.maxWidth -
                                totalHorizontalPadding -
                                horizontalSpacing;
                            double itemWidth = availableWidth / 2;

                            return Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: theme.backgroundGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                spacing: horizontalSpacing,
                                runSpacing: 12,
                                children: [
                                  /*  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Average Package',
                                            placementData.averagePackage,
                                            itemWidth,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Highest Package',
                                            placementData.highestPackage,
                                            itemWidth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Placement Rate',
                                            placementData.placementRate,
                                            itemWidth,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Number of Companies Visited',
                                            placementData
                                                .numberOfCompanyVisited,
                                            itemWidth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),
                      const Text(
                        'Branch-wise Package Stats',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      placementStatsTable(),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),
                      const Text(
                        'Package Distribution',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPackageBar(
                        'Above 20 LPA',
                        double.parse(placementData.aboveTwenty) / 100,
                      ),
                      _buildPackageBar(
                        '15-20 LPA',
                        double.parse(placementData.fifteenToTwenty) / 100,
                      ),
                      _buildPackageBar(
                        '10-15 LPA',
                        double.parse(placementData.tenToFifteen) / 100,
                      ),
                      _buildPackageBar(
                        '5-10 LPA',
                        double.parse(placementData.fiveToTen) / 100,
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),
                      const Text(
                        'Top Recruiters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 18,
                        runSpacing: 16,
                        children:
                            placementData.companiesVisited.map((company) {
                              return _buildRecruiterChip(company);
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 22),
                      const Text(
                        'Recent Placements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children:
                            placementData.recentPlacements.map<Widget>((
                              placement,
                            ) {
                              RegExp regExp = RegExp(r'^(.*?)(?:\s*-\s*(.*))$');
                              var match = regExp.firstMatch(placement);
                              if (match != null) {
                                var name = match.group(1);
                                var package = match.group(2);
                                return _buildRecentPlacement(name!, package!);
                              }
                              return SizedBox.shrink();
                            }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget placementStatsTable() {
    final theme = ThemeController.to.currentTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => theme.filterSelectedColor,
        ),
        columns: [
          DataColumn(
            label: Text(
              'Branch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.filterTextColor,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Highest CTC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.filterTextColor,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Average CTC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.filterTextColor,
              ),
            ),
          ),
        ],

        rows:
            placementData.branchWisePlacement.map((branch) {
              return DataRow(
                cells: [
                  DataCell(Text(branch.branch)),
                  DataCell(Text(branch.highestPackage + 'LPA')),
                  DataCell(Text(branch.averagePackage + 'LPA')),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageBar(String label, double percent) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percent,
                      child: Container(
                        height: 13,
                        decoration: BoxDecoration(
                          color: theme.filterSelectedColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    });
  }

  Widget _buildRecruiterChip(String label) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _buildRecentPlacement(String name, String package) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 35,
            backgroundColor: theme.selectedTextBackground,
            child: Icon(
              Icons.person,
              size: 28,
              color: theme.filterSelectedColor,
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(package),
        ),
      );
    });
  }
}
