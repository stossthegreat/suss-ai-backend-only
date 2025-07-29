import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../models/app_models.dart';
import 'app_icons.dart';

class TabItemWidget extends StatefulWidget {
  final TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItemWidget({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<TabItemWidget> createState() => _TabItemWidgetState();
}

class _TabItemWidgetState extends State<TabItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.bounceCurve,
    ));
    
    _colorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(TabItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(
                  _backgroundAnimation.value * 0.1,
                ),
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with animation
                  AnimatedContainer(
                    duration: AppConstants.fastAnimation,
                    padding: const EdgeInsets.all(2),
                    child: AppIcons.getIcon(
                      widget.tab.iconData,
                      size: 20,
                      color: Color.lerp(
                        AppColors.textGray400,
                        AppColors.primaryPink,
                        _colorAnimation.value,
                      )!,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label with color animation
                  Text(
                    widget.tab.label,
                    style: TextStyle(
                      color: Color.lerp(
                        AppColors.textGray400,
                        AppColors.primaryPink,
                        _colorAnimation.value,
                      ),
                      fontSize: 12,
                      fontWeight: widget.isSelected 
                          ? FontWeight.w600 
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 