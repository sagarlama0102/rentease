import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TiltPanImage extends StatefulWidget {
  final String imageUrl;
  final double height;

  const TiltPanImage({
    super.key, 
    required this.imageUrl, 
    this.height = 300,
  });

  @override
  State<TiltPanImage> createState() => _TiltPanImageState();
}

class _TiltPanImageState extends State<TiltPanImage> {
  // xAlignment: -1.0 (Left), 0.0 (Center), 1.0 (Right)
  double xAlignment = 0.0;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  @override
  void initState() {
    super.initState();
    // Gyroscope is smoother for rotation than Accelerometer
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      
      if (!mounted) return;

      setState(() {
        // We accumulate the rotation. event.y is the side-to-side tilt.
        // The 0.1 is a sensitivity factor (tweak this to your liking)
        double sensitivity = 0.1; 
        xAlignment = (xAlignment + event.y * sensitivity).clamp(-1.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel(); // Important: Stop listening when screen closed
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Container(
    height: widget.height,
    width: double.infinity,
    clipBehavior: Clip.antiAlias, // This "crops" the giant image to the container edges
    decoration: const BoxDecoration(),
    child: OverflowBox(
      // 1. Force the image to be much wider than the screen
      maxWidth: MediaQuery.of(context).size.width * 2.5, 
      minWidth: MediaQuery.of(context).size.width * 2.5,
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        // 2. This moves the giant image behind the "window"
        alignment: Alignment(xAlignment, 0), 
        child: Image.network(
          widget.imageUrl,
          height: widget.height,
          // 3. Use BoxFit.cover so it fills the height but stays wide
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
}