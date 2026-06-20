import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_viewmodel.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(NotificationViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await vm.send(
      email:   _emailCtrl.text.trim(),
      subject: _subjectCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Mensaje enviado correctamente.' : 'Error al enviar mensaje.'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) {
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _messageCtrl.clear();
      vm.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: Consumer<NotificationViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Enviar notificación'),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.mark_email_read_outlined,
                        size: 64, color: Colors.indigo),
                    const SizedBox(height: 8),
                    const Text(
                      'Enviar correo via Pub/Sub',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo destino',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Ingresa un correo';
                        if (!v.contains('@')) return 'Correo inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _subjectCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Asunto',
                        prefixIcon: Icon(Icons.subject),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Ingresa un asunto' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _messageCtrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Mensaje',
                        prefixIcon: Icon(Icons.message_outlined),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Ingresa un mensaje' : null,
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: vm.isLoading ? null : () => _send(vm),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: vm.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send),
                        label: Text(vm.isLoading ? 'Enviando...' : 'Enviar'),
                      ),
                    ),

                    if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          vm.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
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
}
