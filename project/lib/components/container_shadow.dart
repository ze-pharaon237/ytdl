import 'package:flutter/material.dart';

class ContainerShadowWidget extends StatelessWidget {
  final Widget child;
  final double padding;
  final double margin;
  final Color decorationColor;

  const ContainerShadowWidget({
    super.key,
    required this.child,
    this.padding = 10,
    this.margin = 10,
    this.decorationColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
