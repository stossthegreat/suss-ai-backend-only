import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';

class ResultCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showShareButton;
  final VoidCallback? onShare;

  const ResultCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.showShareButton = true,
    this.onShare,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.slideCurve,
    ));
    _fadeAnimation = Tween<double>(
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
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.xlRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  GlassmorphismUtils.glassCard(
                    padding: widget.padding ?? const EdgeInsets.all(24),
                    backgroundColor: AppColors.backgroundGray800,
                    borderColor: AppColors.borderGray600,
                    child: widget.child,
                  ),
                  if (widget.showShareButton)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: _ShareButton(onPressed: widget.onShare),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShareButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _ShareButton({this.onPressed});

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryPink.withOpacity(_isHovered ? 0.3 : 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryPink.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.share,
          color: AppColors.primaryPink,
          size: 20,
        ),
      ),
    );
  }
} 