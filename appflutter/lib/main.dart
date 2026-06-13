import 'package:flutter/material.dart';
import 'core/storage/token_storage.dart';
import 'presentation/auth/login_view.dart';
import 'presentation/users/users_list_view.dart';

void main() {
  runApp(const CalzadoApp());
}

class CalzadoApp extends StatelessWidget {
  const CalzadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calzado App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const _Splash(),
    );
  }
}

// Decide si ir a Login o directo a la lista según si hay JWT guardado
class _Splash extends StatefulWidget {
  const _Splash();

  @override
  State<_Splash> createState() => _SplashState();
}

class _SplashState extends State<_Splash> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final token = await TokenStorage.getToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => token != null ? const UsersListView() : const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
