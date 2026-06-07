part of 'budget_cubit.dart';

@immutable
sealed class BudgetState {}

final class BudgetInitial extends BudgetState {}
final class BudgetLoading extends BudgetState {}
final class BudgetLoaded  extends BudgetState {}
final class BudgetError extends BudgetState {
  final String message;
  BudgetError(this.message);
}
