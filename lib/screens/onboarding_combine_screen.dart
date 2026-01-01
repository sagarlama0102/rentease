// import 'package:flutter/material.dart';
// import 'package:rentease/screens/onboarding_one_screen.dart';
// import 'package:rentease/screens/onboarding_screen.dart';
// import 'package:rentease/screens/onboarding_two_screen.dart';

// class OnboardingCombineScreen extends StatefulWidget {
//   const OnboardingCombineScreen({super.key});

//   @override
//   State<OnboardingCombineScreen> createState() =>
//       _OnboardingCombineScreenState();
// }

// class _OnboardingCombineScreenState extends State<OnboardingCombineScreen> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;

//   List<Widget> onboardingScreens = [
//     OnboardingOneScreen(),
//     OnboardingTwoScreen(),
//     OnboardingScreen(), // your existing screen
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView(
//             controller: _controller,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             children: onboardingScreens,
//           ),
          
//           if(_currentPage <2)
//           Positioned(
//             bottom: 100,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 2,
//                 (index) => buildDot(index, context),
//               ),
//             ),
//           ),
        
          
//         ],
//       ),
//     );
//   }

//   // // Page indicator dot
//   // Widget buildDot(int index, BuildContext context) {
//   //   return AnimatedContainer(
//   //     duration: Duration(milliseconds: 300),
//   //     margin: EdgeInsets.symmetric(horizontal: 6),
//   //     height: 12,
//   //     width: _currentPage == index ? 24 : 12,
//   //     decoration: BoxDecoration(
//   //       color: _currentPage == index ? Color(0xff142725) : Colors.grey[400],
//   //       borderRadius: BorderRadius.circular(6),
//   //     ),
//   //   );
//   // }
// }
