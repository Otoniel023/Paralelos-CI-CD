import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user_model.dart';
import 'user_form_viewmodel.dart';

class UserFormView extends StatefulWidget {
  final UserModel? user; // null = crear, non-null = editar
  const UserFormView({super.key, this.user});

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _formKey     = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidoCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;
  String _rol = 'cliente';

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _nombreCtrl   = TextEditingController(text: u?.nombre   ?? '');
    _apellidoCtrl = TextEditingController(text: u?.apellido ?? '');
    _emailCtrl    = TextEditingController(text: u?.email    ?? '');
    _passCtrl     = TextEditingController();
    _rol          = u?.rol ?? 'cliente';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(UserFormViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    bool ok;
    if (_isEdit) {
      ok = await vm.updateUser(
        id:       widget.user!.id,
        nombre:   _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        rol:      _rol,
        password: _passCtrl.text.isEmpty ? null : _passCtrl.text,
      );
    } else {
      ok = await vm.createUser(
        nombre:   _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        password: _passCtrl.text,
        rol:      _rol,
      );
    }

    if (ok && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserFormViewModel(),
      child: Consumer<UserFormViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_isEdit ? 'Editar usuario' : 'Nuevo usuario'),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(_nombreCtrl, 'Nombre', Icons.person_outline,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    _field(_apellidoCtrl, 'Apellido', Icons.person_outline,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    _field(_emailCtrl, 'Email', Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: (v) => !v!.contains('@') ? 'Email inválido' : null),
                    const SizedBox(height: 16),
                    _field(
                      _passCtrl,
                      _isEdit ? 'Nueva contraseña (opcional)' : 'Contraseña',
                      Icons.lock_outline,
                      obscure: true,
                      validator: (v) {
                        if (!_isEdit && (v == null || v.length < 4)) {
                          return 'Mínimo 4 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _rol,
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'admin',    child: Text('Admin')),
                        DropdownMenuItem(value: 'vendedor', child: Text('Vendedor')),
                        DropdownMenuItem(value: 'cliente',  child: Text('Cliente')),
                      ],
                      onChanged: (v) => setState(() => _rol = v!),
                    ),
                    const SizedBox(height: 8),

                    if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: vm.isLoading ? null : () => _submit(vm),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: vm.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isEdit ? 'Guardar cambios' : 'Crear usuario'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
