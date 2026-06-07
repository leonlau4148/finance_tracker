import 'dart:convert';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../entities/category_entity.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _api;
  CategoryRepository(this._api);

  Future<List<CategoryModel>> getAll() async {
    final res = await _api.authGet(ApiConstants.categories);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list
          .map((e) => CategoryModel.fromEntity(CategoryEntity.fromJson(e)))
          .toList();
    }
    throw Exception('Failed to load categories.');
  }

  Future<CategoryModel> create(String name, String type, String icon) async {
    final res = await _api.authPost(ApiConstants.categories, {
      'name': name, 'type': type, 'icon': icon,
    });
    if (res.statusCode == 201) {
      return CategoryModel.fromEntity(
          CategoryEntity.fromJson(jsonDecode(res.body)));
    }
    throw Exception('Failed to create category.');
  }

  Future<CategoryModel> update(int id, String name, String type, String icon) async {
    final res = await _api.authPut(ApiConstants.categoryById(id), {
      'name': name, 'type': type, 'icon': icon,
    });
    if (res.statusCode == 200) {
      return CategoryModel.fromEntity(
          CategoryEntity.fromJson(jsonDecode(res.body)));
    }
    throw Exception('Failed to update category.');
  }

  Future<void> delete(int id) async {
    final res = await _api.authDelete(ApiConstants.categoryById(id));
    if (res.statusCode != 204) throw Exception('Failed to delete category.');
  }
}
