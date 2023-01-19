import 'dart:io';

import 'package:buku_saku/cpb_list_service.dart';
import 'package:buku_saku/dummy/dashboard.dart';
import 'package:buku_saku/dummy/login.dart';
import 'package:buku_saku/dummy/shared_pref.dart';
import 'package:buku_saku/function/func_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'cpb_menu.dart';
import 'function/func_ftp.dart';

class CpbDetailService extends StatefulWidget {
  @override
  _CpbDetailServiceState createState() => _CpbDetailServiceState();
}

class _CpbDetailServiceState extends State<CpbDetailService> {

  TextEditingController n_id = TextEditingController();
  TextEditingController n_barang = TextEditingController();
  TextEditingController n_status = TextEditingController();
  TextEditingController n_serial = TextEditingController();

  DateTime now = DateTime.now();
  String barang = "";
  String id = "";
  String serial = "";
  String status = "";
  String pilihan = "";

  getData() async{
    SharedPreferences prefer = await SharedPreferences.getInstance();
    

    id = prefer.getString('n_id');
    barang = prefer.getString('n_items');
    serial = prefer.getString('n_serial');
    status = prefer.getString('n_statuss');

    n_id.text = id;
    n_barang.text = barang;
    n_serial.text = serial;
    n_status.text = status;

    print(n_barang.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    // print(barang);
  }

  var stat = [
    'Pengecekan',
    'Pending',
    'Selesai',
    'OnProgress',
  ];



  String defaultItem = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    defaultItem = stat.first;
    return MaterialApp(
        title: "Update Service PC",
        home: Scaffold(
            resizeToAvoidBottomInset: false,

            appBar: AppBar(
              title: Center(
                child: Text("Tambah Data Service"),
              ),
            ),
            body: SingleChildScrollView(
                reverse: true,
                child:Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'ID Barang',
                          ),
                          controller: n_id,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Nama Barang',
                          ),
                          controller: n_barang,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Nomor Serial',
                          ),
                          controller: n_serial,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Status Barang',
                          ),
                          value: defaultItem,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: stat.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String newVal) {
                            setState(() {
                              defaultItem = newVal;
                              pilihan = newVal;
                              print(newVal);
                            });
                          },
                        ),
                      ),

                      Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('Submit'),
                            onPressed: () {
                              print(defaultItem);
                              setState(() {
                                submit(n_id.text,pilihan);
                              });
                              // test();
                            },
                          )),

                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: Text("Jika tidak ada DAT/Serial number, isi dengan '-'"),
                      )
                    ],
                  ),
                )
            )));
  }

  Future submit(String id, String status) async {
    final String apiUrl = "http://reshajtama.my.id/crudphp/records/data_service/"+id;
    // print(apiUrl);
    String timestamp = DateFormat('yyyyMMdd_kkmm').format(now);

    var data = jsonEncode({
      "n_status":status,
      "finish_at":timestamp
    });
    // print(data);
    try{
      if(status.isEmpty){
        alertdialog(context, "Pastikan Semua Form Terisi","");
      }else{
        final response = await http.put(Uri.parse(apiUrl),
            body: data,
            encoding: Encoding.getByName("utf-8"));
        print(response.statusCode.toString());
        if(response.statusCode == 200){
          print("Succes Tambah Data");
          Navigator.pop(context,true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CpbListPage()));
        }else{
          // alertdialog(context, "Gagal Tambah Data",'');
          print("Gagal Tambah Data");
          Navigator.pop(context,true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CpbListPage()));
        }
      }
    }catch(e){
      print(e);
    }
  }

  alertdialog(context,String message,String statusCode){
    AlertDialog alert = AlertDialog(
      content: Container(
        child: Text(message),
      ),
      actions: [
        TextButton(
            child: Text('Ok'),
            onPressed: () => {
              Navigator.pop(context,true),
              if(statusCode == "200"){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CpbListMenuPage()),)
              }else if(statusCode == ""){

              }else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CpbListMenuPage()),)
              }

            }
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
    return;
  }

}

