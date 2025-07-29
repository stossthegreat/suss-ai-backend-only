import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PageTransition extends StatefulWidget {
  final Widget child;
  final int index;
  final int previousIndex;

  const PageTransition({
    super.key,
    required this.child,
    required this.index,
    required this.previousIndex,
  });

  @override
  State<PageTransition> createState() => _PageTransitionState();
}

class _PageTransitionState extends State<PageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    
    // Determine slide direction based on tab index
    final direction = widget.index > widget.previousIndex ? 1.0 : -1.0;
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(direction * 0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.slideCurve,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _controller.forward();
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
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
} 