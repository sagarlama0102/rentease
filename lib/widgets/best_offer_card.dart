// import 'package:flutter/material.dart';
// import 'package:rentease/models/property.dart';
// import 'package:rentease/widgets/icon_badge.dart';

// class BestOfferCard extends StatelessWidget {
//   final Property property;
//   const BestOfferCard({super.key, required this.property});

//   @override
//   Widget build(BuildContext context) {
//     final double cardWidth = MediaQuery.of(context).size.width * 0.8;
//     return Container(
//       width: cardWidth,
//       margin: EdgeInsets.only(right: 16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Stack(
//           children: [
//             Image.asset(
//               property.imageUrl,
//               height: 250,
//               width: cardWidth,
//               fit: BoxFit.cover,
//             ),
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     stops: [0.5, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       property.title,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       property.price,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Colors.white, size: 20),
//                         SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             property.location,
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12),
//                     Row(
//                       children: [
//                         IconBadge(icon: Icons.bed, text: '${property.beds}Bed'),
//                         SizedBox(width: 8),
//                         IconBadge(
//                           icon: Icons.shower,
//                           text: '${property.baths}Bath',
//                         ),
//                         SizedBox(width: 8),
//                         IconBadge(icon: Icons.crop_square, text: property.area),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 100,
//               right: 16,
//               child: CircleAvatar(
//                 radius: 24,
//                 backgroundColor: Colors.white,
//                 backgroundImage:  AssetImage('assets/images/personimage.png'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/widgets/icon_badge.dart';

class BestOfferCard extends StatelessWidget {
  final PropertyEntity property; 
  
  const BestOfferCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    // Using the exact IP you confirmed is working in ProfileScreen
    // Ensure this points to the root of your server where 'public' or 'uploads' are served
    const String imageServerUrl = "http://192.168.101.11:4000";

    final String imageUrl = property.propertyImages.isNotEmpty 
        ? "$imageServerUrl${property.propertyImages[0]}" 
        : 'https://via.placeholder.com/400';

    final double cardWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // IMAGE SECTION
            Image.network(
              imageUrl,
              height: 250,
              width: cardWidth,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                Container(
                  color: Colors.grey.shade200, 
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 40)
                ),
            ),
            
            // GRADIENT OVERLAY
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),

            // PROPERTY DETAILS
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 22, 
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Rs. ${property.price}",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${property.address}, ${property.city}",
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconBadge(icon: Icons.bed, text: '${property.bhk} BHK'),
                        const SizedBox(width: 8),
                        IconBadge(icon: Icons.home_work, text: property.propertyType),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}