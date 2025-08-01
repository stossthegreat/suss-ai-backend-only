import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/mock_data.dart';
import '../../models/history_item.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with TickerProviderStateMixin {
  // ✅ REUSED from Phase 2: 
  // - MockData.getMockHistory() for realistic history items
  // - HistoryItem model with all necessary fields
  late List<HistoryItem> _historyItems;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    // ✅ REUSED: MockData.getMockHistory() with exact React history data
    _historyItems = MockData.getMockHistory();
    _setupAnimations();
    _startStaggeredAnimations();
  }

  void _setupAnimations() {
    // ✅ REUSED: AppConstants animation durations and curves
    _animationControllers = List.generate(
      _historyItems.length,
      (index) => AnimationController(
        duration: AppConstants.slowAnimation, // 500ms per item
        vsync: this,
      ),
    );

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 50.0, // Slide in from 50px down
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AppConstants.slideCurve, // easeOutCubic
      ));
    }).toList();

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AppConstants.defaultCurve, // easeInOut
      ));
    }).toList();
  }

  void _startStaggeredAnimations() {
    // ✅ EXACT React: Staggered entrance animations (150ms delay between each)
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section - EXACTLY like React
          _buildHeader(),
          const SizedBox(height: 24),
          
          // History List - EXACTLY like React with staggered animations
          Expanded(
            child: ListView.builder(
              itemCount: _historyItems.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationControllers[index],
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimations[index].value),
                      child: Opacity(
                        opacity: _fadeAnimations[index].value,
                        child: _buildHistoryCard(_historyItems[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 100), // Bottom padding for tab bar
        ],
      ),
    );
  }

  // ✅ HEADER - Matches React: Simple title only
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Scan History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ✅ HISTORY CARD - Matches React: Compact card with all scan info
  Widget _buildHistoryCard(HistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Space between cards
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ REUSED: Same glassmorphism styling as other cards
        color: AppColors.backgroundGray800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
        border: Border.all(
          color: AppColors.borderGray600,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ EXACT React: Header with preview text and timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message preview (quoted text)
              Expanded(
                child: Text(
                  item.preview,
                  style: TextStyle(
                    color: AppColors.textGray300,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Copy button
              GestureDetector(
                onTap: () => _copyToClipboard(item.preview),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryPink.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.copy,
                    color: AppColors.primaryPink,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Timestamp in top-right
              Text(
                item.date,
                style: TextStyle(
                  color: AppColors.textGray500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Primary Motive section
          Text(
            'Primary Motive:',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.motive,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Score with emoji and color coding
          Row(
            children: [
              Text(
                AppColors.getScoreEmoji(item.score), // ✅ REUSED: Score emoji system
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.score}/100',
                style: TextStyle(
                  color: AppColors.getScoreColor(item.score), // ✅ REUSED: Color coding
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Copy to clipboard functionality
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied to clipboard!'),
        backgroundColor: AppColors.primaryPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
      ),
    );
  }
} 