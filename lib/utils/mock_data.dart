import '../models/analysis_result.dart';
import '../models/history_item.dart';
import '../models/pattern_analysis.dart';

class MockData {
  // Mock Analysis Results
  static AnalysisResult getMockAnalysis(String toneStyle) {
    final comebacks = {
      'brutal': '"You\'re not deep — you\'re just vague because it keeps me chasing. That\'s not mystery, that\'s control."',
      'soft': '"I prefer clarity over mystery in my connections."',
      'clinical': '"Subject displays avoidant attachment patterns with intentional communication ambiguity."',
    };

    return AnalysisResult(
      headline: '🧨 This isn\'t mystery — it\'s manipulation.',
      motive: 'Performing mysterious unavailability to seem desirable',
      redFlag: 84,
      redFlagTier: 'Emotional Vampire Zone',
      feeling: 'Intrigued at first, frustrated by the guessing, and eventually resentful you ever gave them access to your peace.',
      subtext: 'They\'re breadcrumbing you while keeping options open. The vagueness? Intentional. The stories? Bait. This is classic avoidant behavior rebranded as "just living my life."',
      comeback: comebacks[toneStyle] ?? comebacks['brutal']!,
      pattern: 'This is a common play among emotionally unavailable people who want loyalty without giving clarity. You\'re being kept "warm" while they explore.',
      lieDetector: const LieDetectorResult(
        verdict: 'Likely Dishonest',
        isHonest: false,
        cues: [
          'Vague time references ("been busy lately")',
          'Missing direct statements of intent',
          'Overuse of ambiguity ("just seeing where things go")',
        ],
        gutCheck: 'If it feels like you\'re not getting the full picture — you probably aren\'t. This reads like selective honesty, not full clarity.',
      ),
    );
  }

  // Mock History Items
  static List<HistoryItem> getMockHistory() {
    return [
      const HistoryItem(
        id: 1,
        preview: '"Just living my best life 🌟"',
        motive: 'Validation seeking after breakup',
        score: 89,
        date: '2h ago',
        category: 'story',
      ),
      const HistoryItem(
        id: 2,
        preview: '"Sorry for the late reply, been so busy..."',
        motive: 'Breadcrumbing with fake urgency',
        score: 76,
        date: '1d ago',
        category: 'dm',
      ),
      const HistoryItem(
        id: 3,
        preview: '"Not looking for anything serious rn"',
        motive: 'Commitment phobia disguised as honesty',
        score: 82,
        date: '3d ago',
        category: 'bio',
      ),
    ];
  }

  // Mock Pattern Analysis
  static PatternAnalysis getMockPatternAnalysis() {
    return const PatternAnalysis(
      compositeRedFlagScore: 87,
      dominantMotive: 'Control through emotional manipulation',
      patternType: 'Emotional Hook & Retreat',
      emotionalSummary: 'You feel like you\'re constantly chasing their approval while they keep moving the goalposts. Classic push-pull manipulation.',
      lieDetector: LieDetectorResult(
        verdict: 'Likely Dishonest Pattern',
        isHonest: false,
        cues: [
          'Inconsistent emotional availability across messages',
          'Strategic timing of responses to maintain control',
          'Vague promises without concrete follow-through',
        ],
        gutCheck: 'This pattern suggests calculated emotional manipulation rather than genuine uncertainty.',
      ),
    );
  }

  // Mock Comebacks
  static Map<String, String> getMockComebacks() {
    return {
      'mature': '"I prefer direct communication over guessing games."',
      'savage': '"Your inconsistency is more predictable than your affection."',
      'petty': '"I see you\'re practicing your disappearing act again."',
      'playful': '"Are we playing hard to get or hard to understand? Asking for a friend."',
    };
  }
} 