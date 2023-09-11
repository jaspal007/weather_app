import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Widget widget;
  double elevation;
  MyCard({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.widget,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black87,
      elevation: elevation,
      color: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: widget,
      ),
    );
  }
}
