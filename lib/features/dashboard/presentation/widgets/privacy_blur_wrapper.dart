import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class PrivacyBlurWrapper extends StatefulWidget {
  final Widget child;
  const PrivacyBlurWrapper({super.key, required this.child});

  @override
  State<PrivacyBlurWrapper> createState() => _PrivacyBlurWrapperState();
}

class _PrivacyBlurWrapperState extends State<PrivacyBlurWrapper> {
  bool _isNear = false;
  late StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ProximitySensor.events.listen((int event) {
      setState(() {
        // event == 1 means something is close to the sensor
        _isNear = (event > 0);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isNear)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Icon(Icons.lock_outline, color: Colors.white, size: 80),
              ),
            ),
          ),
      ],
    );
  }
}