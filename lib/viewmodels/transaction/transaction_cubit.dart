import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction_model.dart';
import '../../repositories/transaction_repository.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repo;
  TransactionCubit(this._repo) : super(TransactionInitial());

  Future<void> onInitial() {
    return loadTransactions();
  }

  Future<void> loadTransactions() async {
    final filter =
        state is TransactionLoaded ? (state as TransactionLoaded).filter : 'all';
    emit(TransactionLoading());
    try {
      emit(TransactionLoaded(await _repo.getAll(), filter: filter));
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Updates the active list filter ('all' | 'income' | 'expense').
  void setFilter(String filter) {
    final s = state;
    if (s is TransactionLoaded) emit(s.copyWith(filter: filter));
  }

  Future<void> addTransaction(Map<String, dynamic> body) async {
    try {
      await _repo.create(body);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> editTransaction(int id, Map<String, dynamic> body) async {
    try {
      await _repo.update(id, body);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> removeTransaction(int id) async {
    try {
      await _repo.delete(id);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
