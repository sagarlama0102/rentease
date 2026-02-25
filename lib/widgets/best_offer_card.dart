
import 'package:flutter/material.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/widgets/icon_badge.dart';

class BestOfferCard extends StatelessWidget {
  final PropertyEntity property; 
  
  const BestOfferCard({super.key, required this.property});

  
@override
Widget build(BuildContext context) {


  final String imageUrl = property.propertyImages.isNotEmpty 
      ? "${ApiEndpoints.baseUrlOnly}${property.propertyImages[0]}" 
      : 'https://via.placeholder.com/400';

 

  return Container(
    
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // IMAGE SECTION
          Positioned.fill( 
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
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),

          // PROPERTY DETAILS
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10), 
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
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
                          property.city, 
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconBadge(icon: Icons.bed, text: property.bhk),
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