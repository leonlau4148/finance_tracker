import 'package:equatable/equatable.dart';


/// Raw shape returned by the .NET API — matches the JSON field names exactly.
class BudgetEntity extends Equatable {
  final int id;
  final int categoryId;
  final String categoryName;
  final double limitAmount;
  final double spentAmount;
  final int month;
  final int year;

  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.limitAmount,
    required this.spentAmount,
    required this.month,
    required this.year,
  });

  factory BudgetEntity.fromJson(Map<String, dynamic> json) => BudgetEntity(
        id:           json['id']           as int,
        categoryId:   json['categoryId']   as int,
        categoryName: (json['categoryName'] as String?) ?? '',
        limitAmount:  (json['limitAmount']  as num).toDouble(),
        spentAmount:  (json['spentAmount']  as num?)?.toDouble() ?? 0.0,
        month:        json['month']         as int,
        year:         json['year']          as int,
      );

  @override
  List<Object?> get props => [id, categoryId, categoryName, limitAmount, spentAmount, month, year];
}
