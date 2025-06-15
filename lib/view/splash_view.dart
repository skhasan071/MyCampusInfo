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
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.token == '' ? Firstpage() : HomePage(widget.token)));
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
              Image.asset('assets/my_campus_info_logo_no_bg.png', width: size.width * 0.5, fit: BoxFit.cover,),
              SizedBox(height: 6,),
              Text('MyCampusInfo', style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                fontFamily: 'Poppins',
                color: Colors.black,
                letterSpacing: 1.5,
              ),),
              SizedBox(height: 4,),
              SizedBox(
                width: size.width * 0.65,
                child: Text('College Discovery - Helping Students Make Informed Choices', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
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
