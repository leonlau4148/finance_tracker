import 'package:equatable/equatable.dart';

/// Raw shape returned by the .NET API — no business logic here.
class AuthEntity extends Equatable {
  final String token;

  const AuthEntity({required this.token});

  factory AuthEntity.fromJson(Map<String, dynamic> json) =>
      AuthEntity(token: json['token'] as String);

  @override
  List<Object?> get props => [token];
}
