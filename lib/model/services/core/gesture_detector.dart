import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomGestureDetector extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final Function? onDoubleTap;
  const CustomGestureDetector(
      {super.key, required this.child, this.onTap, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.lightImpact();
          onTap!();
        }
      },
      onDoubleTap: () {
        if (onDoubleTap != null) {
          HapticFeedback.lightImpact();
          onDoubleTap!();
        }
      },
      child: child,
    );
  }
}
