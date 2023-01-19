import 'dart:convert';

import 'package:buku_saku/cpb_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cpb_splashscreen.dart';
import 'dummy/dashboard.dart';
import 'cpb_menu.dart';
import 'dummy/login.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: CpbSplashScreenApp(),
      ),
    );
  }
}
