import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tecnofit/home_page.dart';

String responseValue = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  var _wasLoggedSuccess = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.blue,
              Colors.white,
            ])),
        child: LayoutBuilder(builder: (context, contrainsts) {
          var inputContainerSize = screenWidth * 0.9;
          var butttonContainerSize = screenWidth * 0.3;

          return Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.2,
                      child: Image.asset('assets/fit.png'),
                    ),
                    Container(
                      width: inputContainerSize,
                      child: TextFormField(
                        controller: _emailController,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Por favor, digite seu email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: inputContainerSize,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Por favor, digite sua senha';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        maxLength: 15,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                            width: butttonContainerSize,
                            height: screenHeight * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff0054A6), // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () async {
                                FocusScopeNode _currentNode =
                                    FocusScope.of(context);
                                if (_formKey.currentState!.validate()) {
                                  if (!_currentNode.hasPrimaryFocus) {
                                    _currentNode.unfocus();
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _wasLoggedSuccess = await login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (_wasLoggedSuccess) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomePage(
                                        token: responseValue,
                                      );
                                    }));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(responseValue),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

Future<bool> login({required String email, required String password}) async {
  var url = Uri.parse('https://reqres.in/api/register');
  var response = await http.post(
    url,
    body: {'email': email, 'password': password},
  );

  if (response.statusCode == 200) {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', jsonDecode(response.body)['token']);
    responseValue = jsonDecode(response.body)['token'];
    return true;
  } else {
    responseValue = jsonDecode(response.body)['error'];
    return false;
  }
}
