// import 'package:college_app/view/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// import 'StateCity.dart';
//  // Assuming this is where you're navigating
//
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   String? selectedState;
//   String? selectedCity;
//
//   final List<String> states = ["Maharasgtra", "Gujarat"];
//   final Map<String, List<String>> cities = {
//     "Maharashtra": ["Mumbai"],
//     "Gujarat": ["Ahmedabad", "Surat"]
//   };
//
//   void validateAndNavigate() {
//     if (selectedState != null && selectedCity != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage()

//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select both fields!"),
//           backgroundColor: Colors.purple,
//         ),
//       );
//     }
//   }
//
//   Future<void> getCurrentLocation() async {
//     // Mobile-specific code using geolocator package
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Location services are disabled. Please enable them!"),
//           backgroundColor: Colors.purple,
//         ),
//       );
//       return;
//     }
//
//     // Request location permissions
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Location permissions are permanently denied. Please enable them from settings!"),
//           backgroundColor: Colors.purple,
//         ),
//       );
//       return;
//     }
//
//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     // Log the position values
//     print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
//
//     // Reverse geocoding to get state and city
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       // Log the placemarks to see the result
//       print("Placemark Results: $placemarks");
//
//       // Check if placemarks are returned
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//
//         setState(() {
//           selectedState = place.administrativeArea!;  // State
//           selectedCity = place.locality!;  // City
//         });
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Statecity(
//                   state: selectedState!,
//                   city:selectedCity!,
//                 )));
//       } else {
//         // Handle case where no placemarks are returned
//         print("No placemarks found!");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Could not determine the state and city"),
//             backgroundColor: Colors.purple,
//           ),
//         );
//       }
//     } catch (e) {
//       print("Error in reverse geocoding: $e");  // Log reverse geocoding error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Error during reverse geocoding"),
//           backgroundColor: Colors.purple,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           "WELCOME USER",
//           style: TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // State Dropdown
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 30),
//               child: DropdownButtonFormField<String>(
//                 value: selectedState,
//                 hint: const Text("Select Your State"),
//                 items: states
//                     .map((state) => DropdownMenuItem(
//                   value: state,
//                   child: Text(state),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedState = value;
//                     selectedCity = null;
//                   });
//                 },
//                 decoration: dropdownDecoration(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // City Dropdown
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 30),
//               child: DropdownButtonFormField<String>(
//                 value: selectedCity,
//                 hint: const Text("Select Your City"),
//                 items: (selectedState != null)
//                     ? cities[selectedState]!
//                     .map((city) => DropdownMenuItem(
//                   value: city,
//                   child: Text(city),
//                 ))
//                     .toList()
//                     : [],
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCity = value;
//                   });
//                 },
//                 decoration: dropdownDecoration(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Button to get current location
//             Container(
//               height: 50,
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 30),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//                 ),
//                 onPressed: getCurrentLocation,
//                 child: const Text("Get Current Location",
//                     style: TextStyle(color: Colors.white, fontSize: 20)),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Find Button
//             Container(
//               height: 50,
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 30),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//                 ),
//                 onPressed: validateAndNavigate,
//                 child: const Text("Find",
//                     style: TextStyle(color: Colors.white, fontSize: 20)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Decoration for dropdown
//   InputDecoration dropdownDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.pink[50],
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:html' as html;

import 'StateCity.dart'; // For web location access


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? selectedState;
  String? selectedCity;

  final List<String> states = ["Goa", "Gujarat"];
  final Map<String, List<String>> cities = {
    "Goa": ["beach", "beach"],
    "Gujarat": ["Ahmedabad", "Surat"]
  };

  void validateAndNavigate() {
    if (selectedState != null && selectedCity != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Statecity(
            state: selectedState!,
            city: selectedCity!,)
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both fields!"),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }
  Future<void> getCurrentLocation() async {
    if (kIsWeb) {
      // Web-specific code using HTML5 Geolocation API
      try {
        html.window.navigator.geolocation.getCurrentPosition().then((position) async {
          final latitude = position.coords!.latitude;  // This might be of type `num?`
          final longitude = position.coords!.longitude;  // This might be of type `num?`

          // Log latitude and longitude values
          print("Latitude: $latitude, Longitude: $longitude");

          // Ensure latitude and longitude are valid and not null
          if (latitude != null && longitude != null) {
            final double lat = latitude.toDouble();  // Convert to double
            final double lon = longitude.toDouble();  // Convert to double

            print("Converted Latitude: $lat, Longitude: $lon");

            try {
              // Reverse geocoding to get state and city
              List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

              // Log the placemarks to see if any data is returned
              print("Placemark Results: $placemarks");

              // Check if placemarks are returned
              if (placemarks.isNotEmpty) {
                Placemark place = placemarks[0];
                print("Found Placemark: ${place.administrativeArea}, ${place.locality}");

                setState(() {
                  selectedState = place.administrativeArea;
                  selectedCity = place.locality;
                });
              } else {
                // Handle case where no placemarks are returned
                print("No placemarks found!");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Could not determine the state and city"),
                    backgroundColor: Colors.purple,
                  ),
                );
              }
            } catch (e) {
              print("Error in reverse geocoding: $e");  // Log reverse geocoding error
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error during reverse geocoding"),
                  backgroundColor: Colors.purple,
                ),
              );
            }
          } else {
            // Handle null latitude or longitude
            print("Latitude or Longitude is null!");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Location data is unavailable"),
                backgroundColor: Colors.purple,
              ),
            );
          }
        });
      } catch (e) {
        print("Error fetching location: $e");  // Log error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to get location on web"),
            backgroundColor: Colors.purple,
          ),
        );
      }
    } else {
      // Mobile-specific code using geolocator package
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location services are disabled. Please enable them!"),
            backgroundColor: Colors.purple,
          ),
        );
        return;
      }

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permissions are permanently denied. Please enable them from settings!"),
            backgroundColor: Colors.purple,
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Log the position values
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      // Reverse geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

        // Log the placemarks to see the result
        print("Placemark Results: $placemarks");

        // Check if placemarks are returned
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          print("//////////${placemarks[0]}");

          setState(() {
            selectedState = place.administrativeArea;
            selectedCity = place.locality;
          });
        } else {
          // Handle case where no placemarks are returned
          print("No placemarks found!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not determine the state and city"),
              backgroundColor: Colors.purple,
            ),
          );
        }
      } catch (e) {
        print("Error in reverse geocoding: $e");  // Log reverse geocoding error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error during reverse geocoding"),
            backgroundColor: Colors.purple,
          ),
        );
      }
    }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "WELCOME USER",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                value: selectedState,
                hint: const Text("Select Your State"),
                items: states
                    .map((state) => DropdownMenuItem(
                  value: state,
                  child: Text(state),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    selectedCity = null;
                  });
                },
                decoration: dropdownDecoration(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                value: selectedCity,
                hint: const Text("Select Your City"),
                items: (selectedState != null)
                    ? cities[selectedState]!
                    .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
                    .toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                decoration: dropdownDecoration(),
              ),
            ),
            const SizedBox(height: 10),
            // Button to get current location
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: getCurrentLocation,
                child: const Text("Get Current Location",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: validateAndNavigate,
                child: const Text("Find",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.pink[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
