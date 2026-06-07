import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repo;

  final formKey      = GlobalKey<FormState>();
  final nameCtrl     = TextEditingController();
  final emailCtrl    = TextEditingController();
  final passwordCtrl = TextEditingController();

  /// Visual-only field, read directly by the page; any emit triggers rebuild.
  bool obscure = true;

  RegisterCubit(this._repo) : super(RegisterInitial());

  void onInitial() {
    nameCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
    obscure = true;
    emit(RegisterInitial());
  }

  void toggleObscure() {
    obscure = !obscure;
    emit(RegisterInitial()); // rebuild to reflect the toggle
  }

  /// Returns true on success so the page can navigate.
  Future<bool> submit() async {
    emit(RegisterLoading());
    try {
      await _repo.register(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passwordCtrl.text,
      );
      emit(RegisterSuccess());
      return true;
    } catch (e) {
      emit(RegisterError(e.toString().replaceAll('Exception: ', '')));
      return false;
    }
  }

  @override
  Future<void> close() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    return super.close();
  }
}
