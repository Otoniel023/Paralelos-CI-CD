import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

class UserRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<List<UserModel>> getAll() async {
    final res = await _dio.get(ApiConstants.usuarios);
    return (res.data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel> getById(int id) async {
    final res = await _dio.get('${ApiConstants.usuarios}/$id');
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<UserModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post(ApiConstants.usuarios, data: data);
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<UserModel> update(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('${ApiConstants.usuarios}/$id', data: data);
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _dio.delete('${ApiConstants.usuarios}/$id');
  }

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post(ApiConstants.upload, data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<void> sendNotification({
    required String email,
    required String subject,
    required String message,
  }) async {
    await _dio.post(ApiConstants.notifications, data: {
      'email': email,
      'subject': subject,
      'message': message,
    });
  }
}
