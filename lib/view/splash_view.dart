import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_campus_info/view/SignUpLogin/FirstPage.dart';
import 'package:my_campus_info/view/home_page.dart';
import 'package:my_campus_info/view/splash_view_2.0.dart';

class SplashView extends StatefulWidget {

  final String token;
  const SplashView({required this.token, super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    Timer(Duration(seconds: 5), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashView2(token: widget.token)));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/splash-logo.png', width: size.width * 0.45, fit: BoxFit.fitWidth,),
              SizedBox(height: 28,),
              Text('MyCampusInfo', style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30,
                fontFamily: 'Poppins',
                color: Colors.black,
                letterSpacing: 2,
              ),),
              SizedBox(height: 6,),
              SizedBox(
                width: size.width * 0.6,
                child: Text('College Discovery - Helping Students Make Informed Choices', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ), textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      
      ),
    );
  }
  
}
