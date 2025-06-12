import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Modern black app bar
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Text(
          'No Notifications Available',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
