import 'package:equatable/equatable.dart';
import '../entities/transaction_entity.dart';

/// Domain model — used by the app, not tied to JSON structure.
class TransactionModel extends Equatable {
  final int      id;
  final double   amount;
  final String   type;        // "income" | "expense"
  final String   description;
  final DateTime transactionDate; // parsed from raw string
  final String   category;
  final int?     categoryId; // absent in the list payload; present on create/update

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.transactionDate,
    required this.category,
    this.categoryId,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) =>
      TransactionModel(
        id:              entity.id,
        amount:          entity.amount,
        type:            entity.type,
        description:     entity.description,
        transactionDate: DateTime.parse(entity.transactionDate),
        category:        entity.category,
        categoryId:      entity.categoryId,
      );

  /// Serialises to JSON for POST / PUT requests
  Map<String, dynamic> toJson() => {
        'categoryId':      categoryId,
        'amount':          amount,
        'type':            type,
        'description':     description,
        'transactionDate': _formatDate(transactionDate),
      };

  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props =>
      [id, amount, type, description, transactionDate, category, categoryId];
}
