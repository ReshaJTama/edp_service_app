import 'package:buku_saku/cpb_menu.dart';
import 'package:buku_saku/dummy/dashboard.dart';
import 'package:buku_saku/dummy/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginApp> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                  child: FlutterLogo(
                    size: 40,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Username',
                    ),
                    controller: username,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Password',
                    ),
                    controller: password,
                  ),
                ),
                Container(
                    height: 80,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Log In'),
                      onPressed: () {
                        submit(context, username.text, password.text);
                      },
                    )),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  void submit(BuildContext context, String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      final snackBar = SnackBar(

        duration: const Duration(seconds: 5),
        content: Text("username dan password harus diisi"),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    proses_login(context,username, password);
  }

  proses_login(BuildContext context,String username, String password) async {
    final String apiUrl = "https://reshajtama.my.id/example/index.php";
    String txtUser;
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
          body: {
            "username": username,
            "password": password,
          });

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final result = json.decode(response.body.toString());
        if (output['data'][0]["status"] == 1) {
          txtUser = output['data'][0]['username'].toString();

          // SharedPref.setData("username", username);
          // SharedPref.setData("password", password);
          // SharedPref.setData("status", "1");
          

          if (context != null) {
            AlertDialog alert = AlertDialog(
              title: Text("Login Berhasil"),
              content: Container(
                child: Text("Selamat Anda Berhasil login " + txtUser),
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => CpbListMenuPage())),
                ),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
            return;
          };
        }
      }else {
        print("Login Failed");
      }
    } catch (e) {
      debugPrint('$e');
    }
  }
}


