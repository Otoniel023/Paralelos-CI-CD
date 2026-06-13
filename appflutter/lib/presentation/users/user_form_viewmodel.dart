import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

enum UserFormState { idle, loading, success, error }

class UserFormViewModel extends ChangeNotifier {
  final _repo = UserRepository();

  UserFormState _state = UserFormState.idle;
  String?       _error;

  UserFormState get state     => _state;
  String?       get error     => _error;
  bool          get isLoading => _state == UserFormState.loading;

  Future<bool> createUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required String rol,
  }) async {
    return _submit(() => _repo.create({
      'nombre':   nombre,
      'apellido': apellido,
      'email':    email,
      'password': password,
      'rol':      rol,
    }));
  }

  Future<bool> updateUser({
    required int    id,
    required String nombre,
    required String apellido,
    required String email,
    required String rol,
    String?         password,
  }) async {
    final data = <String, dynamic>{
      'nombre':   nombre,
      'apellido': apellido,
      'email':    email,
      'rol':      rol,
    };
    if (password != null && password.isNotEmpty) data['password'] = password;
    return _submit(() => _repo.update(id, data));
  }

  Future<bool> _submit(Future<UserModel> Function() action) async {
    _state = UserFormState.loading;
    _error = null;
    notifyListeners();

    try {
      await action();
      _state = UserFormState.success;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map?)?['error'] as String? ?? 'Error de red';
      _state = UserFormState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Error inesperado';
      _state = UserFormState.error;
      notifyListeners();
      return false;
    }
  }
}
