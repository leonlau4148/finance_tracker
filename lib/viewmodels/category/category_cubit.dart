import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category_model.dart';
import '../../repositories/category_repository.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repo;
  CategoryCubit(this._repo) : super(CategoryInitial());

  // ── Data held on the cubit; the sealed state only signals load status ────────
  List<CategoryModel> categories = const [];

  List<CategoryModel> get expenses {
    return categories.where((c) {
      return c.type == 'expense';
    }).toList();
  }
  List<CategoryModel> get incomes {
    return categories.where((c) {
      return c.type == 'income';
    }).toList();
  }

  Future<void> onInitial() {
    return loadCategories();
  }

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      categories = await _repo.getAll();
      emit(CategoryLoaded());
    } catch (e) {
      emit(CategoryError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> addCategory(String name, String type, String icon) async {
    try {
      await _repo.create(name, type, icon);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateCategory(int id, String name, String type, String icon) async {
    try {
      await _repo.update(id, name, type, icon);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      await _repo.delete(id);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
