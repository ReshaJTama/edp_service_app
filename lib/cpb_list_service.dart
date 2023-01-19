import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'cpb_detail_service.dart';

import 'function/func_sharedpref.dart';

class CpbListPage extends StatefulWidget {
  const CpbListPage({Key key}) : super(key: key);

  @override
  _CpbListPageState createState() => _CpbListPageState();
}

class AppConstant {
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
}

class _CpbListPageState extends State<CpbListPage> {

  String barang = "";
  String n_serial ="";
  TextEditingController n_serial_search = TextEditingController();

  Future<List<dynamic>> _fecthDataUsers(String n_serial) async {
    final apiUrl =
        "http://reshajtama.my.id/crudphp/records/data_service?filter=n_serial,sw,"+n_serial;
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['records'];
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  _loadSharedPreferences() async{
    setState(() {
      barang = getBarang();
    });
  }

showData() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.getString("n_serial");
}

setSerial(String n_id,String n_serial,String n_barang,String n_status) async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString("n_id", n_id);
    await pref.setString("n_serial", n_serial);
    await pref.setString("n_items", n_barang);
    await pref.setString("n_status", n_status);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child:Text("List Service"))
        ),
        body:Column(
          children: [
            SizedBox(child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: n_serial_search,
                ),
              ),
            ),),
            SizedBox(child:Center(
              child: ElevatedButton(
                child: Text("Search Serial"),
                onPressed: (){
                  n_serial = n_serial_search.text;
                  setState(() {
                    _fecthDataUsers(n_serial);
                  });
                  // print(n_serial);
                },
              ),
            )),
            Expanded(child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: _fecthDataUsers(n_serial),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            // title: Text(snapshot.data[index]['n_id'].toString()+". barang:"+snapshot.data[index]['n_barang'].toString()+" Status"+snapshot.data[index]['n_status'].toString()),
                            title: FlatButton(
                              padding: EdgeInsets.zero,
                              // onPressed: () => print('on tap'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(snapshot.data[index]['n_id'].toString()+". barang:"+snapshot.data[index]['n_barang'].toString()),
                                  Text(snapshot.data[index]['n_status'].toString())
                                ],
                              ),
                            ),
                            subtitle: Text(snapshot.data[index]['n_serial'].toString()),
                            onTap: () async {
                              var d = await showData();
                              SharedPreferences prefer = await SharedPreferences.getInstance();
                              await prefer.setString("n_id",snapshot.data[index]['n_id'].toString());
                              setSerial(snapshot.data[index]['n_id'].toString(),snapshot.data[index]['n_serial'].toString(),snapshot.data[index]['n_barang'].toString(),snapshot.data[index]['n_status'].toString());
                              setState(() {
                                print("ID"+ snapshot.data[index]['n_id'].toString());
                                print(prefer.getString('n_id'));
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CpbDetailService()));
                            },
                          );
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: Text("Data Sedang di Load"),
                      ),
                    );
                  }
                },
              ),
            ))
          ],
        )
      ),
    );
  }
}
