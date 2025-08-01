class Category {
  final String id;
  final String label;
  final String? desc;

  const Category({
    required this.id,
    required this.label,
    this.desc,
  });
}

class ToneStyle {
  final String id;
  final String label;
  final String desc;

  const ToneStyle({
    required this.id,
    required this.label,
    required this.desc,
  });
}

class ComebackTone {
  final String id;
  final String label;
  final String desc;

  const ComebackTone({
    required this.id,
    required this.label,
    required this.desc,
  });
}

// 🚀 WHISPERFIRE NEW MODELS
class RelationshipContext {
  final String id;
  final String label;
  final String desc;

  const RelationshipContext({
    required this.id,
    required this.label,
    required this.desc,
  });
}

class AnalysisGoal {
  final String id;
  final String label;
  final String desc;

  const AnalysisGoal({
    required this.id,
    required this.label,
    required this.desc,
  });
}

class ComebackStyle {
  final String id;
  final String label;
  final String desc;

  const ComebackStyle({
    required this.id,
    required this.label,
    required this.desc,
  });
}

class TabItem {
  final String id;
  final String label;
  final String iconData; // We'll use icon names as strings
  
  const TabItem({
    required this.id,
    required this.label,
    required this.iconData,
  });
} 