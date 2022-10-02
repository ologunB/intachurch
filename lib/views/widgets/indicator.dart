import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final height;
  final width;
  final active;
  final inactive;
  final index;
  final length;
  final radius;
  final margin;

  Indicator({
    this.height,
    this.width,
    this.active,
    this.inactive,
    this.index,
    this.length,
    this.radius,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPageIndicator(length, index),
    );
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 500),
      height: height,
      width: isActive ? width + 5 : width,
      margin: EdgeInsets.only(right: margin),
      decoration: BoxDecoration(
        borderRadius: isActive ? BorderRadius.circular(radius) : null,
        shape: isActive ? BoxShape.rectangle : BoxShape.circle,
        color: isActive ? active : inactive,
      ),
    );
  }

  List<Widget> _buildPageIndicator(int length, int index) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == index ? indicator(true) : indicator(false));
    }
    return list;
  }
}
