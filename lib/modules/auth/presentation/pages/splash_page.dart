import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../stores/auth_store.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    _authStore = GetIt.I.get<AuthStore>();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final isLoggedIn = await _authStore.checkIsLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
