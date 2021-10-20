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
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        double gifWidthtSize = screenWidth * 0.4;
        double gifHeightSize = screenHeight * 0.4;

        if (constraints.maxWidth < 1200) {
          gifWidthtSize = screenWidth * 0.6;
          gifHeightSize = screenHeight * 0.6;
        }

        return Center(
          child: SizedBox(
            width: gifWidthtSize,
            height: gifHeightSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/runner.gif',
                ),
                const Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

Future<void> isUserLogged(context) async {
  await Future.delayed(const Duration(milliseconds: 1500));
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
