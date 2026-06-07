import 'package:equatable/equatable.dart';
import '../entities/category_entity.dart';

/// Domain model — used by the app, not tied to JSON structure.
class CategoryModel extends Equatable {
  final int    id;
  final String name;
  final String type; // "income" | "expense"
  final String icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory CategoryModel.fromEntity(CategoryEntity entity) => CategoryModel(
        id:   entity.id,
        name: entity.name,
        type: entity.type,
        icon: entity.icon,
      );

  /// Serialises to JSON for POST / PUT requests
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'icon': icon,
      };

  @override
  List<Object?> get props => [id, name, type, icon];
}
