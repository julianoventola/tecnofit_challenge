import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnofit/splash_page.dart';

class HomePage extends StatelessWidget {
  final String token;
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(token),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actionsOverflowButtonSpacing: 20,
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          ElevatedButton(
                            onPressed: () async {
                              SharedPreferences _sharedPreferences =
                                  await SharedPreferences.getInstance();
                              _sharedPreferences.clear();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SplashPage();
                              }));
                            },
                            child: const Text("Sair"),
                          ),
                        ],
                        content: const Text(
                          "Deseja sair?",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      );
                    });
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
