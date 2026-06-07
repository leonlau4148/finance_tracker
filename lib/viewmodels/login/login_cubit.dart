import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repo;

  final formKey      = GlobalKey<FormState>();
  final emailCtrl    = TextEditingController();
  final passwordCtrl = TextEditingController();

  /// Visual-only field, read directly by the page; any emit triggers rebuild.
  bool obscure = true;

  LoginCubit(this._repo) : super(LoginInitial());

  void onInitial() {
    emailCtrl.clear();
    passwordCtrl.clear();
    obscure = true;
    emit(LoginInitial());
  }

  void toggleObscure() {
    obscure = !obscure;
    emit(LoginInitial()); // rebuild to reflect the toggle
  }

  /// Returns true on success so the page can navigate.
  Future<bool> submit() async {
    emit(LoginLoading());
    try {
      await _repo.login(emailCtrl.text.trim(), passwordCtrl.text);
      emit(LoginSuccess());
      return true;
    } catch (e) {
      emit(LoginError(e.toString().replaceAll('Exception: ', '')));
      return false;
    }
  }

  @override
  Future<void> close() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    return super.close();
  }
}
