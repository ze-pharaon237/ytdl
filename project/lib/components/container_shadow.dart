import 'package:flutter/material.dart';

class ContainerShadowWidget extends StatelessWidget {
  final Widget child;
  final double padding;
  final double margin;
  final Color? decorationColor;

  const ContainerShadowWidget({
    super.key,
    required this.child,
    this.padding = 10,
    this.margin = 10,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: decorationColor ?? theme.cardColor, // Use cardColor for better contrast
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(isDarkMode ? 0.3 : 0.5), // Adjust shadow opacity for dark mode
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
