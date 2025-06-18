import 'package:my_campus_info/model/cost.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cost extends StatelessWidget {
  final String collegeId;
  final String collegeName;
  final String collegeImage;

  const Cost({
    super.key,
    required this.collegeId,
    required this.collegeName,
    required this.collegeImage,
  });

  Future<CostModel?> fetchCostData(String collegeId) async {
    try {
      final response = await http.get(
        Uri.parse("https://tc-ca-server.onrender.com/api/colleges/cost/$collegeId"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CostModel.fromJson(jsonData); // No need to extract costDetails
      } else {
        return null;
      }
    } catch (e) {
      print("Cannot fetch data please retry.");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Cost & Location',
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
        body: FutureBuilder<CostModel?>(
          future: fetchCostData(collegeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.filterSelectedColor,
                ),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text("Cannot fetch data please retry."));
            }

            final cost = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Image.network(
                        collegeImage,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collegeName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                cost.address,
                                style: TextStyle(
                                  color: theme.filterSelectedColor,
                                  fontSize: 15,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        /*   Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.directions),
                              label: const Text("Directions"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                              label: const Text("Share"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                          ],
                        ),*/
                        const SizedBox(height: 16),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: theme.backgroundGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Cost of Living",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildCostItem(
                                "Monthly Rent (1 BHK)",
                                "₹${cost.costOfLiving.monthlyRent}",
                              ),
                              _buildCostItem(
                                "Monthly Utilities",
                                "₹${cost.costOfLiving.monthlyUtilities}",
                              ),
                              _buildCostItem(
                                "Monthly Transport",
                                "₹${cost.costOfLiving.monthlyTransport}",
                              ),
                              _buildCostItem(
                                "Monthly Groceries",
                                "₹${cost.costOfLiving.monthlyGroceries}",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        const SizedBox(height: 22),
                        const Text(
                          "Nearby Places",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildNearbyItem(
                          Icons.restaurant,
                          "Restaurants",
                          "${cost.nearbyPlaces.restaurants.count}+ within ${cost.nearbyPlaces.restaurants.withinMiles} miles",
                        ),
                        const SizedBox(height: 8),
                        _buildNearbyItem(
                          Icons.local_cafe,
                          "Cafes",
                          "${cost.nearbyPlaces.cafes.count}+ within ${cost.nearbyPlaces.cafes.withinMiles} miles",
                        ),
                        const SizedBox(height: 8),
                        _buildNearbyItem(
                          Icons.shopping_bag,
                          "Shopping",
                          "${cost.nearbyPlaces.shopping.count}+ within ${cost.nearbyPlaces.shopping.withinMiles} miles",
                        ),
                        const SizedBox(height: 8),
                        _buildNearbyItem(
                          Icons.directions_transit,
                          "Public Transport",
                          "${cost.nearbyPlaces.publicTransport.stations} stations nearby",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCostItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyItem(IconData icon, String title, String subtitle) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            top: BorderSide(color: Colors.grey, width: 0.4),
            bottom: BorderSide(color: Colors.grey, width: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.filterSelectedColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 25, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
