import 'dart:async';

import 'package:buku_saku/cpb_add_service.dart';
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
import 'function/func_sharedpref.dart';


class CpbLogoutApp extends StatefulWidget {
  @override
  _CpbLogoutAppState createState() => _CpbLogoutAppState();
}

class _CpbLogoutAppState extends State<CpbLogoutApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogoutProcess();
    Timer(Duration(seconds: 3),
            () =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => CpbLogin2App()
                )
            )
    );
  }

  LogoutProcess() async{
    setState(() {
      Logout_shared();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Anda Akan Logout"),
        ),
      ),
    );
  }

}


