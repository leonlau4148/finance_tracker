import 'package:equatable/equatable.dart';
import '../entities/auth_entity.dart';

/// Domain model — used by the app, not tied to JSON structure.
class AuthModel extends Equatable {
  final String token;

  const AuthModel({required this.token});

  /// Maps from the raw API entity
  factory AuthModel.fromEntity(AuthEntity entity) =>
      AuthModel(token: entity.token);

  @override
  List<Object?> get props => [token];
}
