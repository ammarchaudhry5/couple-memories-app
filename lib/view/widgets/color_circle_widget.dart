import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ColorCircleWidget extends StatelessWidget {
  final Color color;
  final double size;

  const ColorCircleWidget({
    Key? key,
    required this.color,
    this.size = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
