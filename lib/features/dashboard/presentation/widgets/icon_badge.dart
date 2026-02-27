import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconBadge({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade700, width: 1.5),

      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,size: 16,color: Colors.green.shade700,),
          SizedBox(width: 4,),
          Text(
            text,
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
