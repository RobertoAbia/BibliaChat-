/// Entity representing a study plan
class Plan {
  final String id;
  final String name;
  final String description;
  final String? shortDescription;
  final int daysTotal;
  final String? icon;
  final String? targetAudience;
  final DateTime createdAt;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription,
    required this.daysTotal,
    this.icon,
    this.targetAudience,
    required this.createdAt,
  });

  /// Returns emoji for the plan. DB stores emoji directly (👑, 💰, etc.)
  String get iconEmoji {
    if (icon == null || icon!.isEmpty) return '📖';
    // If icon is already an emoji (not a legacy icon code), return directly
    if (!icon!.contains('_') && icon!.length <= 4) return icon!;
    // Legacy icon codes fallback
    switch (icon) {
      case 'self_improvement':
        return '🙏';
      case 'volunteer_activism':
        return '💝';
      case 'favorite':
        return '❤️';
      case 'spa':
        return '🕊️';
      case 'restaurant':
        return '⚖️';
      case 'celebration':
        return '🎉';
      case 'fitness_center':
        return '💪';
      default:
        return '📖';
    }
  }
}
