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

  // Inside BestOfferCard build method
@override
Widget build(BuildContext context) {
  const String imageServerUrl = "http://192.168.101.11:4000";

  final String imageUrl = property.propertyImages.isNotEmpty 
      ? "$imageServerUrl${property.propertyImages[0]}" 
      : 'https://via.placeholder.com/400';

  // REMOVE final double cardWidth = MediaQuery.of(context).size.width * 0.8;

  return Container(
    // REMOVE width: cardWidth, (The Grid will handle the width now)
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // IMAGE SECTION
          Positioned.fill( // Use Positioned.fill to make the image cover the whole card area
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey, size: 30),
              ),
            ),
          ),
          
          // GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 1.0], // Start the dark gradient a bit higher
                ),
              ),
            ),
          ),

          // PROPERTY DETAILS
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10), // Reduced padding for smaller grid cards
              child: Column(
                mainAxisSize: MainAxisSize.min, // Vital: take only as much space as needed
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 16, // Smaller font for grid view
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Rs. ${property.price}",
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 14, 
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 14),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          property.city, // Just show city to save space in grid
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // If IconBadges are still too big, consider wrapping them in a Wrap or removing one
                  SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconBadge(icon: Icons.bed, text: '${property.bhk}'),
                        const SizedBox(width: 4),
                        IconBadge(icon: Icons.home_work, text: property.propertyType),
                      ],
                    ),
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