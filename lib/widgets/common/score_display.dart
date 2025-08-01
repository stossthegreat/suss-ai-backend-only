import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class ScoreDisplay extends StatefulWidget {
  final int score;
  final bool animate;
  final double? fontSize;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.animate = true,
    this.fontSize,
  });

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );
    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.defaultCurve,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ScoreDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != oldWidget.score) {
      _scoreAnimation = IntTween(
        begin: oldWidget.score,
        end: widget.score,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: AppConstants.defaultCurve,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppColors.getScoreEmoji(widget.score),
          style: TextStyle(fontSize: widget.fontSize ?? 32),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return Text(
                  '${_scoreAnimation.value}/100',
                  style: TextStyle(
                    color: AppColors.getScoreColor(widget.score),
                    fontSize: widget.fontSize ?? 28,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Text(
              AppColors.getScoreTier(widget.score),
              style: TextStyle(
                color: AppColors.getScoreColor(widget.score).withOpacity(0.8),
                fontSize: (widget.fontSize ?? 28) * 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 