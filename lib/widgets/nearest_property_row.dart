import 'package:flutter/material.dart';
import 'package:rentease/app/theme/app_colors.dart';
import 'package:rentease/models/property.dart';
import 'package:rentease/widgets/icon_badge.dart';

class NearestPropertyRow extends StatelessWidget {
  final Property property;
  const NearestPropertyRow({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              property.imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  property.price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  property.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}
