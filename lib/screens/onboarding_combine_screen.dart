import 'package:flutter/material.dart';
import 'package:rentease/screens/onboarding_one_screen.dart';
import 'package:rentease/screens/onboarding_screen.dart';
import 'package:rentease/screens/onboarding_two_screen.dart';

class OnboardingCombineScreen extends StatefulWidget {
  const OnboardingCombineScreen({super.key});

  @override
  State<OnboardingCombineScreen> createState() => _OnboardingCombineScreenState();
}

class _OnboardingCombineScreenState extends State<OnboardingCombineScreen> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          OnboardingOneScreen(),
          OnboardingTwoScreen(),
          OnboardingScreen(),   // your existing screen
        ],
      ),
    );
  }
}