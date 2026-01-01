import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/routes/app_routes.dart';
import 'package:rentease/features/auth/presentation/pages/login_page.dart';
import 'package:rentease/screens/login_screen.dart'; // Adjust path
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';

// Your Data Model (can be in this file or a separate one)
class OnboardingPageData {
  final String title;
  final String imagePath;
  final IconData icon;

  OnboardingPageData({
    required this.title,
    required this.imagePath,
    required this.icon,
  });
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 1. YOUR custom content data
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: "Discover your dream home \nin just a few taps..",
      imagePath: 'assets/images/onboardingoneimage.png',
      icon: Icons.home_work,
    ),
    OnboardingPageData(
      title: "Safe and Secure \nRentals for everyone.",
      imagePath: 'assets/images/onboardingtwoimage.png',
      icon: Icons.security,
    ),
    OnboardingPageData(
      title: "List your property \nand start earning.",
      imagePath: 'assets/images/onboardingthreeimage.png',
      icon: Icons.add_business,
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToLogin() {
    // Using your teacher's preferred routing method
    AppRoutes.pushReplacement(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack so the dots and buttons float OVER your background image
      body: Stack(
        children: [
          // 2. The Full Screen Background + Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingContent(item: _pages[index]);
            },
          ),

          // 3. Skip Button (Top Right)
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _navigateToLogin,
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),

          // 4. Bottom Controls (Indicator + Button)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Your custom dots widget
                PageIndicator(
                  itemCount: _pages.length,
                  currentPage: _currentPage,
                  activeColor: const Color(0xff99DAB3), // Your brand green
                ),
                const SizedBox(height: 30),
                
                // Next / Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff142725),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _navigateToLogin();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _pages.length - 1 ? "GET STARTED" : "NEXT",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}