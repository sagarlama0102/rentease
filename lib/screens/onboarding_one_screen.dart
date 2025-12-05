import 'package:flutter/material.dart';

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboardingimage.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_work, size: 140, color: Color(0xff142725)),
              
              SizedBox(height: 20),
              Text(
                "Browse available houses \nnear you with ease.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}