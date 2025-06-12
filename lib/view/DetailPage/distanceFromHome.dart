import 'dart:math';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DistanceFromHometown extends StatefulWidget {
  final double lat;
  final double long;

  const DistanceFromHometown({
    super.key,
    required this.lat,
    required this.long,
    required String collegeId,
  });

  @override
  _DistanceFromHometownState createState() => _DistanceFromHometownState();
}

class _DistanceFromHometownState extends State<DistanceFromHometown> {
  bool isLoading = false;
  String distance = "Fetching...";
  String travelTimeCar = "Fetching...";
  String travelTimeTrain = "Fetching...";
  String travelTimeBus = "Fetching...";

  // Function to calculate distance using Haversine formula
  double calculateDistance(
    double userLat,
    double userLong,
    double lat,
    double long,
  ) {
    const double R = 6371.0; // Radius of the Earth in kilometers

    double phi1 = userLat * pi / 180;
    double phi2 = lat * pi / 180;
    double deltaPhi = (lat - userLat) * pi / 180;
    double deltaLambda = (long - userLong) * pi / 180;

    double a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in kilometers
  }

  // Method to calculate travel time
  String calculateTravelTime(double distance, double speed) {
    double time = distance / speed; // Time = Distance / Speed
    int hours = time.floor(); // Get hours
    int minutes = ((time - hours) * 60).round(); // Get minutes

    return "${hours}h ${minutes}m";
  }

  // Get current location of the user
  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", 'please enable your location to fetch distance');
      setState(() {
        isLoading = false;
      });
      return;
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permissions are permanently denied. Please enable them from settings!",
          ),
          backgroundColor: Colors.purple,
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Get the user's position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Calculate the distance
    double userLat = position.latitude;
    double userLong = position.longitude;

    double calculatedDistance = calculateDistance(
      userLat,
      userLong,
      widget.lat,
      widget.long,
    );

    // Calculate travel times
    setState(() {
      distance = "${calculatedDistance.toStringAsFixed(2)} km";
      travelTimeCar = calculateTravelTime(
        calculatedDistance,
        60,
      ); // Car: 60 km/h
      travelTimeTrain = calculateTravelTime(
        calculatedDistance,
        50,
      ); // Train: 50 km/h
      travelTimeBus = calculateTravelTime(
        calculatedDistance,
        40,
      ); // Bus: 40 km/h
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Distance from Hometown",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loader while fetching
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Distance and Travel Time Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Distance",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                distance,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Travel Time",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                travelTimeCar, // Travel time for car, train, or bus
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TravelOptionCard(
                        icon: Icons.train,
                        title: "By Train",
                        subtitle: travelTimeTrain,
                      ),
                      TravelOptionCard(
                        icon: Icons.directions_bus,
                        title: "By Bus",
                        subtitle: travelTimeBus,
                      ),
                      const SizedBox(height: 24),

                      Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 16),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.filterSelectedColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(),
                          ),
                          onPressed:
                              getCurrentLocation, // Fetch the location when pressed
                          child: const Text(
                            "Get Distance and Time",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      );
    });
  }
}

// Travel Option Card Widget
class TravelOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const TravelOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: theme.boxShadow,
          border: Border.all(
            color: theme.filterSelectedColor, // Border color
            width: 2, // Border width
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: Icon(icon, color: Colors.black),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      );
    });
  }
}
