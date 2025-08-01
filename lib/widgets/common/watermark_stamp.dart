import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/glassmorphism.dart';

class WatermarkStamp extends StatelessWidget {
  final String text;
  final IconData? icon;

  const WatermarkStamp({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismUtils.glassWatermark(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.primaryPink,
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
} 