import 'dart:io';

import 'package:buku_saku/dummy/dashboard.dart';
import 'package:buku_saku/dummy/login.dart';
import 'package:buku_saku/dummy/shared_pref.dart';
import 'package:buku_saku/function/func_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";

import 'cpb_menu.dart';
import 'function/func_ftp.dart';

class CpbAdd extends StatefulWidget {
  @override
  _CpbAddState createState() => _CpbAddState();
}

class _CpbAddState extends State<CpbAdd> {

  TextEditingController n_barang = TextEditingController();
  TextEditingController n_merk = TextEditingController();
  TextEditingController n_serial = TextEditingController();
  TextEditingController n_lisensi = TextEditingController();
  TextEditingController n_dat = TextEditingController();
  TextEditingController n_desc = TextEditingController();
  String SerialPhotoPath = "";
  String LisensiPhotoPath = "";

  String _username = "";
  String _password = "";
  String _nama = "";
  String _status = "";

  DateTime now = DateTime.now();
  String serialText = "";
  String lisensiText = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: "Tambah Service PC",
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
                          labelText: 'Merk',
                        ),
                        controller: n_merk,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Lisensi',
                        ),
                        controller: n_lisensi,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Serial Number',
                        ),
                        controller: n_serial,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'No DAT',
                        ),
                        controller: n_dat,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintMaxLines: 20,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Keterangan',
                        ),
                        controller: n_desc,
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    //   width: 350,
                    //   height: 350,
                    //   child: Image.asset(ImageFilePath)
                    // ),
                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: 80,
                              width: 175,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text('Capture Lisensi'),
                                onPressed: () {
                                  setState(() {
                                    getImage("lisensi");
                                  });
                                  // test();
                                },
                              )
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                height: 80,
                                width: 175,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  child: const Text('Capture Serial'),
                                  onPressed: () {
                                    setState(() {
                                      getImage("serial");
                                    });
                                    // test();
                                  },
                                )
                            )
                          ],
                        )
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
                            setState(() {
                              submit(n_barang.text, n_merk.text, n_serial.text,n_lisensi.text,n_dat.text,n_desc.text,_nama);
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

  getSharedPref() async{
    var d =await  getUserinfo_shared(_username,_nama,_password, _status);
    setState(() {
      _username = d[0].toString();
      _nama = d[1];
      _password = d[2];
      _status = d[3];
    });
  }

  Future submit(String barang, String merk, String serial,String lisensi, String dat, String desc,String pic) async {
    final String apiUrl = "http://reshajtama.my.id/crudphp/records/data_service";
    String timestamp = DateFormat('yyyyMMdd_kkmm').format(now);
    String id_timestamp = DateFormat('yyyyMMddkkmm').format(now);
    String id = "SVC"+dat+id_timestamp.toString();
    log(id);
    serialText = "-";
    lisensiText = "-";

    if(serial != "-" && lisensi != "-"){
      serialText = n_serial.text+"_"+n_dat.text+"_"+timestamp+".jpg";
      lisensiText = n_lisensi.text+"_"+n_dat.text+"_"+timestamp+".jpg";
    }else if(lisensi != "-") {
      lisensiText = n_lisensi.text+"_"+n_dat.text+"_"+timestamp+".jpg";
    }else if(serial != "-"){
      serialText = n_serial.text+"_"+n_dat.text+"_"+timestamp+".jpg";
    }

    var data = jsonEncode({
      "n_id":id,
      "n_barang":barang,
      "n_merk":merk,
      "n_serial":serial,
      "n_lisensi":lisensi,
      "n_dat":dat,
      "n_pic":pic,
      "n_status":"OnProgress",
      "n_desc":desc,
      "img_serial":serialText,
      "img_lisensi":lisensiText,
      "finish_at":"no_time"
    });
    print(data);
    try{
      log(SerialPhotoPath);
      uploadFile(SerialPhotoPath.toString(),n_serial.text+"_"+n_dat.text+"_"+timestamp+".jpg");
      uploadFile(LisensiPhotoPath.toString(),n_lisensi.text+"_"+n_dat.text+"_"+timestamp+".jpg");

      if(barang.isEmpty || merk.isEmpty || serial.isEmpty || dat.isEmpty|| desc.isEmpty){
        alertdialog(context, "Pastikan Semua Form Terisi","");
      }else if(serial != "-" && SerialPhotoPath.isEmpty){
        alertdialog(context, "Foto Serial Belum di isi","");
      }else if(lisensi != "-" && LisensiPhotoPath.isEmpty){
        alertdialog(context, "Foto Lisensi Belum di isi","");
      }else{
        final response = await http.post(Uri.parse(apiUrl),
            body: data,
            encoding: Encoding.getByName("utf-8"));
        print(response.statusCode.toString());
        if(response.statusCode == 200){
          print("Succes Tambah Data");
          alertdialog(context, "Succes Tambah Data",response.statusCode.toString());
        }else{
          alertdialog(context, "Gagal Tambah Data",response.statusCode.toString());
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CpbAdd()),)
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

  Future getImage(String pathname) async{
    final ImagePicker _picker = ImagePicker();
    final XFile photo = await _picker.pickImage(source: ImageSource.camera);
    if(pathname == "lisensi"){
      LisensiPhotoPath = photo.path;
      var result = await FlutterImageCompress.compressAndGetFile(
        LisensiPhotoPath,
        LisensiPhotoPath,
        quality: 66,
      );
    }else if(pathname == "serial"){
      SerialPhotoPath = photo.path;
      var result = await FlutterImageCompress.compressAndGetFile(
        SerialPhotoPath,
        SerialPhotoPath,
        quality: 66,
      );
    }

  }
}

