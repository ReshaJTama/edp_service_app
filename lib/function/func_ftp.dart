import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import "package:flutter_native_image/flutter_native_image.dart";

uploadFile(String path, String name) async{
  FTPConnect ftpConnect = FTPConnect('139.255.198.189',user:'root', pass:'123',port:8091);
  File compressedFile = await FlutterNativeImage.compressImage(path,
      quality: 80, percentage: 30);
  print(path);

  try {
    File fileToUpload = compressedFile;
    String fileName = fileToUpload.path.split('/').last;
    await ftpConnect.connect();
    await ftpConnect.changeDirectory('lisensi');
    await ftpConnect.uploadFile(fileToUpload);
    await ftpConnect.rename(fileName,name);
    await ftpConnect.disconnect();
    print("Success Upload");
  } catch (e) {
    print(e);
  }
}