import 'package:equatable/equatable.dart';

/// Raw shape returned by the .NET API — matches the JSON field names exactly.
class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => CategoryEntity(
        id:   json['id']   as int,
        name: json['name'] as String,
        type: json['type'] as String,
        icon: (json['icon'] as String?) ?? '',
      );

  @override
  List<Object?> get props => [id, name, type, icon];
}
