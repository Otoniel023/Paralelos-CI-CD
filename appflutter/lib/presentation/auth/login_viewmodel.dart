import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/storage/token_storage.dart';

enum AuthState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final _repo = UserRepository();

  AuthState _state = AuthState.idle;
  String?   _error;

  AuthState get state => _state;
  String?   get error => _error;
  bool get isLoading => _state == AuthState.loading;

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      final data = await _repo.login(email, password);
      await TokenStorage.saveToken(data['token'] as String);
      await TokenStorage.saveUser(jsonEncode(data['user']));
      _state = AuthState.success;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map?)?['error'] as String? ?? 'Error de conexión';
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Error inesperado';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    _state = AuthState.idle;
    notifyListeners();
  }
}
