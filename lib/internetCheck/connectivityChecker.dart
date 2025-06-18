import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'noInternetScreen.dart';

class ConnectivityChecker extends StatelessWidget {
  final Widget child;

  ConnectivityChecker({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        // Show loading indicator while checking connectivity
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Check for connectivity status
        if (snapshot.hasError || snapshot.data == ConnectivityResult.none) {
          // If there's no internet, pass the current screen to the "No Internet" screen
          return NoInternetScreen(currentScreen: child);  // Pass current screen as a parameter
        }

        // If connected to the internet, show the actual content
        return child;
      },
    );
  }
}
