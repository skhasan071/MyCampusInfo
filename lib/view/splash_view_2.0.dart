import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_campus_info/model/user.dart';
import 'package:my_campus_info/view/SignUpLogin/FirstPage.dart';
import 'package:my_campus_info/view/home_page.dart';

class SplashView2 extends StatefulWidget {

  final String token;
  const SplashView2({required this.token, super.key});

  @override
  State<SplashView2> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView2> {

  @override
  void initState() {
    Timer(Duration(seconds: 5), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.token == '' ? Firstpage() : HomePage(widget.token)));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Color(0xff29292A),
        
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/MyCampusInfo.png', width: size.width * 0.55, fit: BoxFit.fitWidth,),
            ],
          ),
        ),
      
      ),
    );
  }
  
}
