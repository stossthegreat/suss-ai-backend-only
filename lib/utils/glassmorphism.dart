import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';

class GlassmorphismUtils {
  // Main glassmorphism container
  static Widget glassContainer({
    required Widget child,
    double blur = AppConstants.glassBlur,
    double opacity = AppConstants.glassOpacity,
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color?.withOpacity(opacity) ?? Colors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Card with glassmorphism effect
  static Widget glassCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return glassContainer(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppConstants.mediumSpacing),
      blur: AppConstants.cardBlur,
      opacity: AppConstants.cardOpacity,
      color: backgroundColor ?? const Color(0xFF374151),
      borderRadius: BorderRadius.circular(AppConstants.xlRadius),
      border: Border.all(
        color: borderColor ?? const Color(0xFF4B5563).withOpacity(0.3),
        width: 0.5,
      ),
      child: child,
    );
  }

  // Bottom navigation with glassmorphism
  static Widget glassBottomNav({
    required Widget child,
  }) {
    return glassContainer(
      blur: 24.0,
      opacity: 0.95,
      color: const Color(0xFF111827),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.largeRadius),
        topRight: Radius.circular(AppConstants.largeRadius),
      ),
      border: const Border(
        top: BorderSide(
          color: Color(0xFF374151),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }

  // Watermark stamp with glassmorphism
  static Widget glassWatermark({
    required Widget child,
  }) {
    return glassContainer(
      blur: 16.0,
      opacity: 0.2,
      color: const Color(0xFFEC4899),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: const Color(0xFFEC4899).withOpacity(0.3),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.smallSpacing,
      ),
      child: child,
    );
  }
} 