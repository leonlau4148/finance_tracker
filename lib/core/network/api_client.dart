import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';

class ApiClient {
  Future<Map<String, String>> _headers({bool auth = true}) async {
    final h = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await TokenStorage.get();
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  // Public (no token)
  Future<http.Response> post(String url, Map<String, dynamic> body) async =>
      http.post(Uri.parse(url),
          headers: await _headers(auth: false), body: jsonEncode(body));

  // Protected
  Future<http.Response> authGet(String url) async =>
      http.get(Uri.parse(url), headers: await _headers());

  Future<http.Response> authPost(String url, Map<String, dynamic> body) async =>
      http.post(Uri.parse(url),
          headers: await _headers(), body: jsonEncode(body));

  Future<http.Response> authPut(String url, Map<String, dynamic> body) async =>
      http.put(Uri.parse(url),
          headers: await _headers(), body: jsonEncode(body));

  Future<http.Response> authDelete(String url) async =>
      http.delete(Uri.parse(url), headers: await _headers());
}
