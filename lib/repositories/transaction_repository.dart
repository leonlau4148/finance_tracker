import 'dart:convert';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../entities/transaction_entity.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final ApiClient _api;
  TransactionRepository(this._api);

  Future<List<TransactionModel>> getAll() async {
    final res = await _api.authGet(ApiConstants.transactions);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list
          .map((e) => TransactionModel.fromEntity(TransactionEntity.fromJson(e)))
          .toList();
    }
    throw Exception('Failed to load transactions.');
  }

  Future<TransactionModel> create(Map<String, dynamic> body) async {
    final res = await _api.authPost(ApiConstants.transactions, body);
    if (res.statusCode == 201) {
      return TransactionModel.fromEntity(
          TransactionEntity.fromJson(jsonDecode(res.body)));
    }
    throw Exception('Failed to create transaction.');
  }

  Future<TransactionModel> update(int id, Map<String, dynamic> body) async {
    final res = await _api.authPut(ApiConstants.transactionById(id), body);
    if (res.statusCode == 200) {
      return TransactionModel.fromEntity(
          TransactionEntity.fromJson(jsonDecode(res.body)));
    }
    throw Exception('Failed to update transaction.');
  }

  Future<void> delete(int id) async {
    final res = await _api.authDelete(ApiConstants.transactionById(id));
    if (res.statusCode != 204) throw Exception('Failed to delete transaction.');
  }
}
