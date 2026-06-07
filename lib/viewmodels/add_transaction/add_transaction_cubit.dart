import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/transaction_repository.dart';
part 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final CategoryRepository    _categoryRepo;
  final TransactionRepository _transactionRepo;

  /// Form key + text controllers owned by the cubit so the page holds no state.
  final formKey    = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final descCtrl   = TextEditingController();

  // ── Form fields, held directly on the cubit (read by the page) ───────────────
  List<CategoryModel> categories = const [];
  bool                isEdit     = false;
  int?                editingId;
  String              type       = 'expense'; // 'income' | 'expense'
  int?                categoryId;
  DateTime            date       = DateTime(2000); // overwritten by onInitial

  AddTransactionCubit(this._categoryRepo, this._transactionRepo)
      : super(AddTransactionInitial());

  /// Categories filtered to the currently-selected type.
  List<CategoryModel> get categoriesForType {
    return categories.where((c) {
      return c.type == type;
    }).toList();
  }

  /// Seeds the form from an existing transaction (edit) or defaults (add),
  /// then loads the categories for the dropdown.
  Future<void> onInitial(TransactionModel? existing) async {
    amountCtrl.text = existing?.amount.toString() ?? '';
    descCtrl.text   = existing?.description ?? '';
    isEdit     = existing != null;
    editingId  = existing?.id;
    type       = existing?.type ?? 'expense';
    date       = existing?.transactionDate ?? DateTime.now();
    categoryId = existing?.categoryId;
    await loadCategories();
  }

  Future<void> loadCategories() async {
    emit(AddTransactionLoading());
    try {
      categories = await _categoryRepo.getAll();
      emit(AddTransactionReady());
    } catch (e) {
      emit(AddTransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void setType(String newType) {
    type = newType;
    categoryId = null; // switching type clears the selection (per-type categories)
    emit(AddTransactionReady());
  }

  void setCategory(int? id) {
    categoryId = id;
    emit(AddTransactionReady());
  }

  void setDate(DateTime newDate) {
    date = newDate;
    emit(AddTransactionReady());
  }

  /// Persists the form. Returns true on success so the page can pop.
  Future<bool> submit() async {
    final body = {
      'categoryId':      categoryId,
      'amount':          double.parse(amountCtrl.text),
      'type':            type,
      'description':     descCtrl.text.trim(),
      'transactionDate': _formatDate(date),
    };
    emit(AddTransactionSubmitting());
    try {
      if (isEdit) {
        await _transactionRepo.update(editingId!, body);
      } else {
        await _transactionRepo.create(body);
      }
      emit(AddTransactionSuccess());
      return true;
    } catch (e) {
      emit(AddTransactionError(e.toString().replaceAll('Exception: ', '')));
      return false;
    }
  }

  static String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() {
    amountCtrl.dispose();
    descCtrl.dispose();
    return super.close();
  }
}
