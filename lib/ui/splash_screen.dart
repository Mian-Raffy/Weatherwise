import 'dart:async';

import 'package:WeatherWise/ui/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Container(
            height: 150.0,
            width: 150.0,
            child: Image.asset('images/w.png'),
          )),
          const Center(
            child: Text(
              "Weather Tracker...",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                color: Colors
                    .black, // Make the text white so it's visible on the background
                fontSize: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
