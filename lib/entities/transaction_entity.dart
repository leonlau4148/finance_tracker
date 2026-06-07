import 'package:equatable/equatable.dart';

/// Raw shape returned by the .NET API — matches the JSON field names exactly.
class TransactionEntity extends Equatable {
  final int    id;
  final double amount;
  final String type;
  final String description;
  final String transactionDate; // raw string e.g. "2026-05-31"
  final String category;
  final int?   categoryId; // absent in the list payload; present on create/update

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.transactionDate,
    required this.category,
    this.categoryId,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      TransactionEntity(
        id:              json['id']              as int,
        amount:          (json['amount'] as num).toDouble(),
        type:            json['type']            as String,
        description:     json['description']     as String,
        transactionDate: json['transactionDate'] as String,
        category:        (json['category']  as String?) ?? '',
        categoryId:      json['categoryId'] as int?,
      );

  @override
  List<Object?> get props =>
      [id, amount, type, description, transactionDate, category, categoryId];
}
