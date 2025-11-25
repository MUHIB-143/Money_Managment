import 'dart:ui';
import 'package:flutter/material.dart';

/// Elevation levels for consistent depth hierarchy
enum GlassElevation {
  none(0, 0),
  low(2, 0.05),
  medium(4, 0.08),
  high(8, 0.12),
  veryHigh(16, 0.15);

  final double elevation;
  final double opacity;

  const GlassElevation(this.elevation, this.opacity);
}

/// A glassmorphic container with backdrop blur effect and consistent elevation
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final double borderWidth;
  final GlassElevation elevation;
  final VoidCallback? onTap;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = 10,
    this.borderColor,
    this.borderWidth = 1,
    this.elevation = GlassElevation.medium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBorderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.3);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // Elevation shadow
          BoxShadow(
            color: Colors.black.withOpacity(elevation.opacity),
            blurRadius: elevation.elevation,
            offset: Offset(0, elevation.elevation / 2),
          ),
          // Subtle glow for depth
          if (elevation != GlassElevation.none)
            BoxShadow(
              color: isDark
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.5),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.05),
                          ]
                        : [
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.5),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: borderColor ?? defaultBorderColor,
                    width: borderWidth,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenient glass card wrapper with standard padding and elevation
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final GlassElevation? elevation;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      borderRadius: borderRadius ?? 16,
      elevation: elevation ?? GlassElevation.medium,
      onTap: onTap,
      child: child,
    );
  }
}
