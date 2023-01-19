import 'dart:async';

import 'package:buku_saku/cpb_add_service.dart';
import 'package:buku_saku/cpb_list_service.dart';
import 'package:buku_saku/dummy/dashboard.dart';
import 'package:buku_saku/dummy/login.dart';
import 'package:buku_saku/dummy/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cpb_login.dart';
import 'cpb_menu.dart';




class CpbSplashScreenApp extends StatefulWidget {
  @override
  _CpbSplashScreenAppState createState() => _CpbSplashScreenAppState();
}

class _CpbSplashScreenAppState extends State<CpbSplashScreenApp> {

  String username = "Test";
  String password = "Test";
  String status = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedData();
    cekLogin();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Center(
          child: Text("Loading"),
        ),
      ),
    );
  }

  getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()  {
      username = prefs.getString("username");
      password = prefs.getString("password");
      status = prefs.getString("status");
    });
  }

  cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()  {
      status = prefs.getString("status");
    });
    print(status);
    if (status == "1") {
      Timer(Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => CpbListMenuPage()
                  )
              )
      );
    } else{
      Timer(Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => CpbLogin2App()
                  )
              )
      );
    }

  }

}
