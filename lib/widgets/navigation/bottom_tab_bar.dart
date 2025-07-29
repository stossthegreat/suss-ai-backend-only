import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';
import '../../models/app_models.dart';
import 'tab_item_widget.dart';

class BottomTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<TabItem> tabs;

  const BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.defaultCurve,
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
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _slideAnimation.value)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassmorphismUtils.glassBottomNav(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: widget.tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    return Expanded(
                      child: TabItemWidget(
                        tab: tab,
                        isSelected: index == widget.currentIndex,
                        onTap: () => widget.onTap(index),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 