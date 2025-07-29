import 'package:flutter/material.dart';
import 'dart:ui';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool enabled;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;

  const CustomTextField({
    super.key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.keyboardType,
    this.padding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.normalAnimation,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
        border: Border.all(
          color: _isFocused
              ? AppColors.primaryPink.withOpacity(0.5)
              : AppColors.borderGray600,
          width: _isFocused ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppConstants.xlRadius),
            ),
            child: Focus(
              onFocusChange: (focused) {
                setState(() {
                  _isFocused = focused;
                });
              },
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                maxLines: widget.maxLines,
                enabled: widget.enabled,
                keyboardType: widget.keyboardType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    color: AppColors.textGray400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 