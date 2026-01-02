import 'package:flutter/material.dart';
import 'package:rentease/features/onboarding/presentation/pages/onboarding_page.dart';



class OnboardingContent extends StatelessWidget {
  final OnboardingPageData item;

  const OnboardingContent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // This applies your full-screen background image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(item.imagePath),
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
            // Your large icon style
            Icon(
              item.icon, 
              size: 140, 
              color: const Color(0xff99DAB3), // Using your brand green for the icon
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}