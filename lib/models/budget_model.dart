import 'package:equatable/equatable.dart';
import '../entities/budget_entity.dart';

/// Domain model — used by the app, not tied to JSON structure.
class BudgetModel extends Equatable {
  final int    id;
  final int    categoryId;
  final String categoryName;
  final double limitAmount;
  final double spentAmount;
  final int    month;
  final int    year;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.limitAmount,
    required this.spentAmount,
    required this.month,
    required this.year,
  });

  // Computed helpers — business logic lives in the model, not the view
  double get remainingAmount  => limitAmount - spentAmount;
  double get progressPercent  =>
      limitAmount > 0 ? (spentAmount / limitAmount).clamp(0.0, 1.0) : 0.0;
  bool   get isOverBudget     => spentAmount > limitAmount;

  factory BudgetModel.fromEntity(BudgetEntity entity) => BudgetModel(
        id:           entity.id,
        categoryId:   entity.categoryId,
        categoryName: entity.categoryName,
        limitAmount:  entity.limitAmount,
        spentAmount:  entity.spentAmount,
        month:        entity.month,
        year:         entity.year,
      );

  Map<String, dynamic> toJson() => {
        'categoryId':  categoryId,
        'limitAmount': limitAmount,
        'month':       month,
        'year':        year,
      };

  @override
  List<Object?> get props =>
      [id, categoryId, categoryName, limitAmount, spentAmount, month, year];
}
