part of 'add_transaction_cubit.dart';

/// Status only — the form fields (type, categoryId, date, categories, …) live
/// on [AddTransactionCubit] and are read directly by the page.
@immutable
sealed class AddTransactionState {}

final class AddTransactionInitial    extends AddTransactionState {}
final class AddTransactionLoading    extends AddTransactionState {} // loading categories
final class AddTransactionReady      extends AddTransactionState {}
final class AddTransactionSubmitting extends AddTransactionState {}
final class AddTransactionSuccess    extends AddTransactionState {}
final class AddTransactionError      extends AddTransactionState {
  final String message;
  AddTransactionError(this.message);
}
