import 'dart:convert';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/utils/token_storage.dart';
import '../entities/auth_entity.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final ApiClient _api;
  AuthRepository(this._api);

  Future<AuthModel> login(String email, String password) async {
    final res = await _api.post(ApiConstants.login, {
      'email': email,
      'password': password,
    });
    if (res.statusCode == 200) {
      final entity = AuthEntity.fromJson(jsonDecode(res.body));
      final model  = AuthModel.fromEntity(entity);
      await TokenStorage.save(model.token);
      return model;
    } else if (res.statusCode == 401) {
      throw Exception('Invalid email or password.');
    }
    throw Exception('Login failed. Please try again.');
  }

  Future<AuthModel> register(String fullName, String email, String password) async {
    final res = await _api.post(ApiConstants.register, {
      'fullName': fullName,
      'email':    email,
      'password': password,
    });
    if (res.statusCode == 200) {
      final entity = AuthEntity.fromJson(jsonDecode(res.body));
      final model  = AuthModel.fromEntity(entity);
      await TokenStorage.save(model.token);
      return model;
    } else if (res.statusCode == 400) {
      throw Exception(jsonDecode(res.body).toString());
    }
    throw Exception('Registration failed. Please try again.');
  }

  Future<void> logout() => TokenStorage.delete();
}
