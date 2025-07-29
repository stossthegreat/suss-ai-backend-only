import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CustomOutlinedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Color? borderColor;
  final Color? selectedColor;
  final Widget? child;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSelected = false,
    this.borderColor,
    this.selectedColor,
    this.child,
    this.width,
    this.padding,
  });

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.defaultCurve,
    ));
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: (widget.selectedColor ?? AppColors.primaryPink).withOpacity(0.1),
    ).animate(_controller);

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomOutlinedButton oldWidget) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: AppConstants.normalAnimation,
              width: widget.width,
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                border: Border.all(
                  color: widget.isSelected
                      ? (widget.selectedColor ?? AppColors.primaryPink)
                      : (widget.borderColor ?? AppColors.borderGray600),
                  width: widget.isSelected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
              child: widget.child ??
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.isSelected
                          ? (widget.selectedColor ?? AppColors.primaryPink)
                          : AppColors.textGray400,
                      fontSize: 14,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ),
          ),
        );
      },
    );
  }
} 