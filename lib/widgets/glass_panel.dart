import 'package:flutter/material.dart';
import '../theme.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double radius;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: HeritageTheme.glassDecoration(
        borderColor: borderColor,
        radius: radius,
      ),
      child: child,
    );
  }
}
