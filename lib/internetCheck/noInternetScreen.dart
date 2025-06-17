import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget currentScreen;  // A parameter to pass the current screen

  NoInternetScreen({required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 50, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check the connectivity status
                var connectivityResult = await Connectivity().checkConnectivity();

                if (connectivityResult == ConnectivityResult.none) {
                  // If there is no internet, show a snackbar or keep the same screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No internet connection. Please check your connection.'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.black,
                    ),
                  );
                } else {
                  // If internet is available, reload the current screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => currentScreen),
                  );
                }
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
