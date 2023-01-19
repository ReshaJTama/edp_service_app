import 'package:buku_saku/cpb_list_service.dart';
import 'package:buku_saku/cpb_logout.dart';
import 'package:buku_saku/function/func_sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cpb_add_service.dart';
// import 'package:smart_home_ui/utils/utils.dart';
// import 'package:smart_home_ui/widgets/widgets.dart';

class CpbListMenuPage extends StatefulWidget {
  const CpbListMenuPage({Key key}) : super(key: key);

  @override
  _CpbListMenuPageState createState() => _CpbListMenuPageState();
}

class AppConstant {
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
}


class _CpbListMenuPageState extends State<CpbListMenuPage> {

  String _username = "";
  String _password = "";
  String _nama = "";
  String _status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPref();
  }

  getSharedPref() async{
    var d =await  getUserinfo_shared(_username,_nama, _password, _status);
    setState(() {
      _username = d[0].toString();
      _nama = d[1];
      _password = d[2];
      _status = d[3];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Menu EDP")),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Center(
                child: ListTile(
                  title: Text("Selamat Datang " + _username ),
                  leading: Icon(Icons.verified_user),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => CpbListPage()));
                  },
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10),
              child: Center(
                child: ListTile(
                  title: Text("Tambah Data Service"),
                  leading: Icon(Icons.document_scanner),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CpbAdd()));
                  },
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10),
              child: Center(
                child: ListTile(
                  title: Text("Update Data Service"),
                  leading: Icon(Icons.list),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CpbListPage()));
                  },
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10),
              child: Center(
                child: ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CpbLogoutApp()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
