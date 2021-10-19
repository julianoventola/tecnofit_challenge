import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnofit/home_page.dart';
import 'package:tecnofit/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    isUserLogged(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Future<void> isUserLogged(context) async {
  await Future.delayed(const Duration(seconds: 1));
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  bool tokenValidation = _sharedPreferences.getString('token') == null;
  Widget page = tokenValidation
      ? const LoginPage()
      : HomePage(
          token: _sharedPreferences.getString('token')!,
        );
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return page;
  }));
}
