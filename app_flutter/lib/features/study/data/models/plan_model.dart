import '../../domain/entities/plan.dart';

/// Data model for Plan with JSON serialization
class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.description,
    super.shortDescription,
    required super.daysTotal,
    super.icon,
    super.targetAudience,
    required super.createdAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String?,
      daysTotal: json['days_total'] as int,
      icon: json['icon'] as String?,
      targetAudience: json['target_audience'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'days_total': daysTotal,
      'icon': icon,
      'target_audience': targetAudience,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
