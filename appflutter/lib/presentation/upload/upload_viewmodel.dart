import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';

enum UploadState { idle, loading, success, error }

class UploadViewModel extends ChangeNotifier {
  final _repo = UserRepository();

  UploadState _state = UploadState.idle;
  String?     _error;
  String?     _uploadedUrl;
  String?     _uploadedFilename;

  UploadState get state            => _state;
  String?     get error            => _error;
  String?     get uploadedUrl      => _uploadedUrl;
  String?     get uploadedFilename => _uploadedFilename;
  bool        get isLoading        => _state == UploadState.loading;

  Future<bool> upload(String filePath) async {
    _state = UploadState.loading;
    _error = null;
    _uploadedUrl = null;
    notifyListeners();

    try {
      final result = await _repo.uploadFile(filePath);
      _uploadedUrl      = result['url'] as String?;
      _uploadedFilename = result['filename'] as String?;
      _state = UploadState.success;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map?)?['error'] as String? ?? 'Error al subir archivo';
      _state = UploadState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Error inesperado';
      _state = UploadState.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = UploadState.idle;
    _error = null;
    _uploadedUrl = null;
    _uploadedFilename = null;
    notifyListeners();
  }
}
