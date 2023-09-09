import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Widget widget;
  const MyCard({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
