import 'package:buku_saku/cpb_menu.dart';
import 'package:buku_saku/function/func_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart';
import 'dart:developer';
import 'cpb_menu_staff.dart';

class CpbLogin2App extends StatefulWidget {
  @override
  _CpbLogin2AppState createState() => _CpbLogin2AppState();
}

class _CpbLogin2AppState extends State<CpbLogin2App> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String _username = "";
  String _password = "";
  String _status = "";
  String apiUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getSharedPref();
  }
  //
  // getSharedPref() async{
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   _status = pref.getString('status');
  // }

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
                            setState(() {
                              submit(context, username.text, password.text);
                            });
                            // test();
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

  // void submit(BuildContext context, String username, String password) {
  //   if (username.isEmpty || password.isEmpty) {
  //   }
  //   proses_login(context,username, password);
  // }

  void Alert(String message) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 150,
        child: Center(
          child: Text(message),
        ),
      ),
    );
    showDialog(context: context, builder: (context) => alert);
    return;
  }

  Future submit(BuildContext context, String username, String password) async {
    // final String apiUrl = "http://reshajtama.my.id/crudphp/records/users?filter=name,eq,"+ username ;
    final String apiUrl =
        "http://reshajtama.my.id/crudphp/records/data_user?filter=nik,eq," +
            username;
    final response = await http.get(Uri.parse(apiUrl));
    final output = await jsonDecode(response.body);

    String md5_password = md5.convert(utf8.encode(password)).toString();

    print(md5_password);

    print(response.statusCode.toString() + "Test");

    try {
      if (username.isEmpty || password.isEmpty) {
        log("Input username/password");
        Alert("Masukan Username dan Password");
      } else {
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          final result = json.decode(response.body.toString());
          if (output['records'][0]['password'] == md5_password &&
              output['records'][0]['level'] == "teknisi") {

            String name = output['records'][0]['nama'];
            log(name);
            Login_shared(username,name,password);
            AlertDialog alert = AlertDialog(
              title: Text("Login Berhasil"),
              content: Container(
                child: Text("Selamat Anda Berhasil login "),
              ),
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed: () => {
                          Navigator.pop(context, true),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CpbListMenuStaffPage()),
                          )
                        }
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //         builder: (context) => CpbListMenuPage())),
                    ),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
            return;
          } else {
            Alert("User tidak terdaftar sebagai Teknisi");
          }
        } else {
          Alert("Server Error " + response.statusCode.toString());
        }
      }
    } catch (e) {}

    // try {
    //   if (username.isEmpty || password.isEmpty) {
    //     AlertDialog alert = AlertDialog(
    //       title: Text("Login Berhasil"),
    //       content: Container(
    //         child: Text("Username & Password harus di isi"),
    //       ),
    //     );
    //     showDialog(context: context, builder: (context) => alert);
    //     return;
    //   }else{
    //     print("200");
    //     if (response.statusCode == 200) {
    //       print("200");
    //       final result = json.decode(response.body.toString());
    //       if (output['records'][0]['password'] == md5_password && output['records'][0]['level'] == "Teknisi") {
    //         Login_shared(username, password);
    //         if (output['records'][0]['level'] == "staff") {
    //           AlertDialog alert = AlertDialog(
    //             title: Text("Login Berhasil"),
    //             content: Container(
    //               child: Text("Selamat Anda Berhasil login "),
    //             ),
    //             actions: [
    //               TextButton(
    //                   child: Text('Ok'),
    //                   onPressed: () =>
    //                   {
    //                     Navigator.pop(context, true),
    //                     Navigator.pushReplacement(context, MaterialPageRoute(
    //                         builder: (context) => CpbListMenuStaffPage()),)
    //                   }
    //                 // Navigator.of(context).pushReplacement(
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => CpbListMenuPage())),
    //               ),
    //             ],
    //           );
    //           showDialog(context: context, builder: (context) => alert);
    //           return;
    //         } else {
    //           print("test");

    //         }
    //       }
    //     }else {
    //       print("running");
    //       snackbar("Login Gagal");
    //     }
    //   }
    // } catch (e) {
    //   snackbar("User tidak di temukan");
    // }
  }
}
