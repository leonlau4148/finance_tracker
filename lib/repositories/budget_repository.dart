import 'dart:convert';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../entities/budget_entity.dart';
import '../models/budget_model.dart';

class BudgetRepository {
  final ApiClient _api;
  BudgetRepository(this._api);

  Future<List<BudgetModel>> getAll() async {
    final res = await _api.authGet(ApiConstants.budgets);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list
          .map((e) => BudgetModel.fromEntity(BudgetEntity.fromJson(e)))
          .toList();
    }
    throw Exception('Failed to load budgets.');
  }

  Future<BudgetModel> create(
      int categoryId, double limitAmount, int month, int year) async {
    final res = await _api.authPost(ApiConstants.budgets, {
      'categoryId':  categoryId,
      'limitAmount': limitAmount,
      'month':       month,
      'year':        year,
    });
    if (res.statusCode == 201) {
      return BudgetModel.fromEntity(
          BudgetEntity.fromJson(jsonDecode(res.body)));
    }
    throw Exception('Failed to create budget.');
  }

  Future<void> delete(int id) async {
    final res = await _api.authDelete(ApiConstants.budgetById(id));
    if (res.statusCode != 204) throw Exception('Failed to delete budget.');
  }
}
