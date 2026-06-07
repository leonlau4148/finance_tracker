part of 'transaction_cubit.dart';

@immutable
sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}
final class TransactionLoading extends TransactionState {}
final class TransactionLoaded  extends TransactionState {
  final List<TransactionModel> transactions;
  final String filter; // 'all' | 'income' | 'expense'
  final double totalIncome;
  final double totalExpense;

  TransactionLoaded(this.transactions, {this.filter = 'all'})
      : totalIncome  = transactions.where((t) {
          return t.type == 'income';
        }).fold(0.0, (s, t) {
          return s + t.amount;
        }),
        totalExpense = transactions.where((t) {
          return t.type == 'expense';
        }).fold(0.0, (s, t) {
          return s + t.amount;
        });

  double get balance {
    return totalIncome - totalExpense;
  }

  /// Transactions narrowed to the active [filter].
  List<TransactionModel> get filteredTransactions {
    return filter == 'all'
        ? transactions
        : transactions.where((t) {
            return t.type == filter;
          }).toList();
  }

  TransactionLoaded copyWith({
    List<TransactionModel>? transactions,
    String? filter,
  }) {
    return TransactionLoaded(
      transactions ?? this.transactions,
      filter: filter ?? this.filter,
    );
  }
}
final class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}
