import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnofit/splash_page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

List randowValues = [];

class HomePage extends StatefulWidget {
  final String token;
  HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: const Color(0xff0054A6),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
                          child: const Text("Cancel"),
                          style: TextButton.styleFrom(
                            primary: const Color(0xff0054A6), // background
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xff0054A6), // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            SharedPreferences _sharedPreferences =
                                await SharedPreferences.getInstance();
                            _sharedPreferences.clear();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const SplashPage();
                            }));
                          },
                          child: const Text(
                            "Sair",
                          ),
                        ),
                      ],
                      content: const Text(
                        "Deseja sair?",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: loadRandomValues(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting &&
                randowValues.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: randowValues.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title:
                          Text('Trainnin style ${randowValues[index]['name']}'),
                      subtitle: Text('${randowValues[index]['pantone_value']}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
                    ),
                  );
                });
          }),
    );
  }
}

Future<void> loadRandomValues() async {
  var url = Uri.parse('https://reqres.in/api/unknown');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body)['data']);
    randowValues = jsonDecode(response.body)['data'];
  }
}
