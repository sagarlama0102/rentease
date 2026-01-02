// import 'package:flutter/material.dart';

// class OnboardingTwoScreen extends StatelessWidget {
//   const OnboardingTwoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/onboardingtwoimage.png'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.4),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.map, size: 140, color: Color(0xff142725)),
//               SizedBox(height: 20),
//               Text(
//                 "See all available properties \nin your area instantly..",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white70, fontSize: 22),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }