import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

// Función top-level requerida por compute() para correr en un Isolate separado
List<Map<String, dynamic>> _filterUsersIsolate(Map<String, dynamic> params) {
  final users = (params['users'] as List).cast<Map<String, dynamic>>();
  final query = (params['query'] as String).toLowerCase();
  if (query.isEmpty) return users;
  return users.where((u) {
    return (u['nombre'] as String).toLowerCase().contains(query) ||
        (u['apellido'] as String).toLowerCase().contains(query) ||
        (u['email'] as String).toLowerCase().contains(query);
  }).toList();
}

class UsersListViewModel extends ChangeNotifier {
  final _repo = UserRepository();

  // Stream — la UI reacciona cada vez que la lista cambia
  final _usersController = StreamController<List<UserModel>>.broadcast();
  Stream<List<UserModel>> get usersStream => _usersController.stream;

  List<UserModel> _allUsers  = [];
  List<UserModel> _filtered  = [];
  UserModel?      _profile;
  bool            _isLoading = false;
  String?         _error;

  List<UserModel> get users     => _filtered;
  UserModel?      get profile   => _profile;
  bool            get isLoading => _isLoading;
  String?         get error     => _error;

  // Future.wait() — carga usuarios + perfil propio en PARALELO
  Future<void> loadDashboard(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.getAll(),
        _repo.getById(userId),
      ]);

      _allUsers = results[0] as List<UserModel>;
      _filtered  = List.from(_allUsers);
      _profile   = results[1] as UserModel;

      // Publica en el Stream para que los listeners reactivos se actualicen
      _usersController.add(_allUsers);
    } catch (e) {
      _error = 'Error al cargar datos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // compute() — filtra en un Isolate separado para no bloquear la UI
  Future<void> filterUsers(String query) async {
    final rawList = _allUsers.map((u) => u.toJson()).toList();

    final filtered = await compute(
      _filterUsersIsolate,
      {'users': rawList, 'query': query},
    );

    _filtered = filtered.map(UserModel.fromJson).toList();
    _usersController.add(_filtered);
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    await _repo.delete(id);
    await _refresh();
  }

  Future<void> _refresh() async {
    _allUsers = await _repo.getAll();
    _filtered  = List.from(_allUsers);
    _usersController.add(_allUsers);
    notifyListeners();
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}
