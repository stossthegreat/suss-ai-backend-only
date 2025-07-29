class Category {
  final String id;
  final String label;

  const Category({
    required this.id,
    required this.label,
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