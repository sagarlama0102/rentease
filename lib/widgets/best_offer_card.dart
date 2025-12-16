import 'package:flutter/material.dart';
import 'package:rentease/models/property.dart';
import 'package:rentease/widgets/icon_badge.dart';

class BestOfferCard extends StatelessWidget {
  final Property property;
  const BestOfferCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              property.imageUrl,
              height: 250,
              width: cardWidth,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      property.price,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        IconBadge(icon: Icons.bed, text: '${property.beds}Bed'),
                        SizedBox(width: 8),
                        IconBadge(
                          icon: Icons.shower,
                          text: '${property.baths}Bath',
                        ),
                        SizedBox(width: 8),
                        IconBadge(icon: Icons.crop_square, text: property.area),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 16,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
