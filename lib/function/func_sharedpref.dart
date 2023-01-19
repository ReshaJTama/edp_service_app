import 'package:shared_preferences/shared_preferences.dart';

Login_shared(String username,String nama, String password) async{
  SharedPreferences pref = await SharedPreferences.getInstance();

  await pref.setString("username", username);
  await pref.setString("nama", nama);
  await pref.setString("password", password);
  await pref.setString("status", "1");
}

Logout_shared() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove("username");
  await  pref.remove("password");
  await  pref.remove("status");
}

Future<List> getUserinfo_shared(String _username,String _nama,String _password, String _status) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
    _username = pref.getString('username');
    _nama = pref.getString('nama');
    _password = pref.getString('password');
    _status = pref.getString('status');
    return [_username,_nama,_password,_status];
}

getBarang() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String barang = (pref.getString('barang')??'');
  return barang;
}

setSerial(String n_id,String n_serial) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("n_id", n_id);
  await pref.setString("n_serial", n_serial);
}

Future<List> getSerialShared(String n_id, String n_serial) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  n_id = pref.getString("n_id");
  n_serial =  pref.getString("n_serial");
  return [n_id,n_serial];
}
