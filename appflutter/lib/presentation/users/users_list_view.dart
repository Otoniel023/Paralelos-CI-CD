import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/storage/token_storage.dart';
import '../../data/models/user_model.dart';
import '../auth/login_view.dart';
import '../upload/upload_view.dart';
import 'users_list_viewmodel.dart';
import 'user_form_view.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final _searchCtrl = TextEditingController();
  late UsersListViewModel _vm;
  int?   _userId;
  String _userRol = 'cliente';

  @override
  void initState() {
    super.initState();
    _vm = UsersListViewModel();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final raw = await TokenStorage.getUser();
    if (raw != null) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _userId  = data['id'] as int?;
      _userRol = data['rol'] as String? ?? 'cliente';
    }
    if (_userId != null) {
      await _vm.loadDashboard(_userId!);
    }
  }

  Future<void> _logout() async {
    await TokenStorage.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }

  void _goToForm({UserModel? user}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => UserFormView(user: user)),
    );
    if (result == true && _userId != null) {
      await _vm.loadDashboard(_userId!);
    }
  }

  void _confirmDelete(BuildContext ctx, UserModel user) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Eliminar a ${user.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _vm.deleteUser(user.id);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<UsersListViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Usuarios'),
                  if (vm.profile != null)
                    Text(
                      '${vm.profile!.fullName} · ${vm.profile!.rol}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  tooltip: 'Subir archivo',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const UploadView()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
            ),

            // FAB solo para admin
            floatingActionButton: _userRol == 'admin'
                ? FloatingActionButton(
                    onPressed: () => _goToForm(),
                    backgroundColor: Colors.indigo,
                    child: const Icon(Icons.person_add, color: Colors.white),
                  )
                : null,

            body: Column(
              children: [
                // Buscador — filtra en Isolate via compute()
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre o email...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: vm.filterUsers,
                  ),
                ),

                // Cuerpo principal — StreamBuilder sobre el Stream del ViewModel
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(vm.error!, style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_userId != null) vm.loadDashboard(_userId!);
                                    },
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : StreamBuilder<List<UserModel>>(
                              stream: vm.usersStream,
                              initialData: vm.users,
                              builder: (context, snapshot) {
                                final list = snapshot.data ?? [];
                                if (list.isEmpty) {
                                  return const Center(child: Text('Sin resultados'));
                                }
                                return ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  itemCount: list.length,
                                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                                  itemBuilder: (context, i) {
                                    final u = list[i];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.indigo.shade100,
                                        child: Text(
                                          u.nombre[0].toUpperCase(),
                                          style: const TextStyle(color: Colors.indigo),
                                        ),
                                      ),
                                      title: Text(u.fullName),
                                      subtitle: Text('${u.email} · ${u.rol}'),
                                      trailing: _userRol == 'admin'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit, color: Colors.indigo),
                                                  onPressed: () => _goToForm(user: u),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () => _confirmDelete(context, u),
                                                ),
                                              ],
                                            )
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
