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

  /// Icon as IconData based on the icon name stored in DB
  String get iconEmoji {
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
