import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/budget_model.dart';
import '../../repositories/budget_repository.dart';
part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository _repo;
  BudgetCubit(this._repo) : super(BudgetInitial());

  // ── Data held on the cubit; the sealed state only signals load status ────────
  List<BudgetModel> budgets = const [];

  Future<void> onInitial() {
    return loadBudgets();
  }

  Future<void> loadBudgets() async {
    emit(BudgetLoading());
    try {
      budgets = await _repo.getAll();
      emit(BudgetLoaded());
    } catch (e) {
      emit(BudgetError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> addBudget(
      int categoryId, double limitAmount, int month, int year) async {
    try {
      await _repo.create(categoryId, limitAmount, month, year);
      await loadBudgets();
    } catch (e) {
      emit(BudgetError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> removeBudget(int id) async {
    try {
      await _repo.delete(id);
      await loadBudgets();
    } catch (e) {
      emit(BudgetError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
