import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';

enum NotificationState { idle, loading, success, error }

class NotificationViewModel extends ChangeNotifier {
  final _repo = UserRepository();

  NotificationState _state = NotificationState.idle;
  String?           _error;

  NotificationState get state     => _state;
  String?           get error     => _error;
  bool              get isLoading => _state == NotificationState.loading;

  Future<bool> send({
    required String email,
    required String subject,
    required String message,
  }) async {
    _state = NotificationState.loading;
    _error = null;
    notifyListeners();

    try {
      await _repo.sendNotification(email: email, subject: subject, message: message);
      _state = NotificationState.success;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map?)?['error'] as String? ?? 'Error al enviar mensaje';
      _state = NotificationState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Error inesperado';
      _state = NotificationState.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = NotificationState.idle;
    _error = null;
    notifyListeners();
  }
}
