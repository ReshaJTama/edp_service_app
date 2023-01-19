import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:audioplayers/audioplayers.dart';

// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // String pathPDF = "";
  // String landscapePathPdf = "";
  String remotePDFpath = "";
  String cek = "asdasf";
  // String corruptedPathPDF = "";
  final String apiUrl = "https://reshajtama.my.id/example/index.json";


  Future playLocal() async {
    String audioasset = "assets/alarm.mp3";
    // final player = AudioCache();
    // await player.play('alarm.mp3');
  }

  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['data'];
  }


   @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
        new Timer.periodic(Duration(seconds: 10), (timer) {setState(() {
          _fecthDataUsers();
        });});

      });
    });
  }


  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = "https://repository.bbg.ac.id/bitstream/651/1/Buku_Guru_Diriku_SDMI_Kelas_I.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title:Text("Alarm Center")),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: _fecthDataUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      if(snapshot.data[index]['status'] == 1){
                        playLocal();
                        String cek= "Cek";
                      }else{
                        String cek="";
                      }
                      return ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: 90,
                              minHeight: 90,
                              maxHeight: 100,
                              maxWidth: 100,
                            ),
                            child: Image.network(snapshot.data[index]['avatar']),
                        ),
                        title: Text(snapshot.data[index]['id'].toString()+""+snapshot.data[index]['first_name']),
                        subtitle: Text(cek),
                      );
                    }
                );
              }else{
                return Container(
                  child: Center(
                    child: Text("Data Sedang di Load"),
                  ),
                );
              }
            },
          ),
        ),
        // body: Center(child:
        // Builder(
        //   builder: (BuildContext context) {
        //     return Container(
        //     child: Card(
        //     child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //     ListTile(
        //     leading: ConstrainedBox(constraints: BoxConstraints(
        //       minWidth: 90,
        //       minHeight: 90,
        //       maxHeight: 100,
        //       maxWidth: 100,
        //     ),
        //       child: Image.network("https://static.buku.kemdikbud.go.id/content/image/coverteks/coverkurikulum21/Bahasa-Indonesia-BG-KLS-I-Cover.png"),
        //     ),
        //     title: Text('The Enchanted Nightingale'),
        //     subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
        //     ),
        //     Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       SizedBox(width: 8,),
        //
        //     ],
        //     ),
        //     ],
        //     ),
        //     ),
        //         // child:Column(
        //         //   children: <Widget>[
        //         //     InkWell(
        //         //         splashColor: Colors.black26,
        //         //         onTap: (){},
        //         //         child: Column(
        //         //           mainAxisSize: MainAxisSize.min,
        //         //           children: [
        //         //             Ink.image(
        //         //               image: NetworkImage('https://images.unsplash.com/photo-1662581871625-7dbd3ac1ca18?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80'),
        //         //               width: 200,
        //         //               height: 200,
        //         //               fit: BoxFit.cover,
        //         //             ),
        //         //             Center(
        //         //               child:Text(
        //         //                 "Test",
        //         //                 style: TextStyle(
        //         //                   fontSize: 32,
        //         //                   color: Colors.black,
        //         //
        //         //                 ),
        //         //               ),
        //         //             ),
        //         //           ],
        //         //         )
        //         //     ),
        //         //     TextButton(
        //         //       child: Text("Remote PDF"),
        //         //       onPressed: () {
        //         //         if (remotePDFpath.isNotEmpty) {
        //         //           Navigator.push(
        //         //             context,
        //         //             MaterialPageRoute(
        //         //               builder: (context) => PDFScreen(path: remotePDFpath),
        //         //             ),
        //         //           );
        //         //         }
        //         //       },
        //         //     ),
        //         //   ],
        //         // )
        //     );
        //
        //   },
        // )),
      ),
    );
  }


}

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({Key key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  // final Completer<PDFViewController> _controller =
  // Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  int halaman = 0;
  bool isReady = false;

  String errorMessage = '';
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // PDFView(
          //   filePath: widget.path,
          //   enableSwipe: true,
          //   swipeHorizontal: true,
          //   autoSpacing: false,
          //   pageFling: true,
          //   pageSnap: true,
          //   defaultPage: currentPage,
          //   fitPolicy: FitPolicy.BOTH,
          //   preventLinkNavigation:
          //   false, // if set to true the link is handled in flutter
          //   onRender: (_pages) {
          //     setState(() {
          //       pages = _pages;
          //       isReady = true;
          //     });
          //   },
          //   onError: (error) {
          //     setState(() {
          //       errorMessage = error.toString();
          //     });
          //     print(error.toString());
          //   },
          //   onPageError: (page, error) {
          //     setState(() {
          //       errorMessage = '$page: ${error.toString()}';
          //     });
          //     print('$page: ${error.toString()}');
          //   },
          //   onViewCreated: (PDFViewController pdfViewController) {
          //     _controller.complete(pdfViewController);
          //   },
          //   onLinkHandler: (String uri) {
          //     print('goto uri: $uri');
          //   },
          //   onPageChanged: (int page, int total) {
          //     print('page change: $page/$total');
          //     setState(() {
          //       currentPage = page;
          //     });
          //   },
          // ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         // label: Text("Go to ${pages ~/ 2}"),
      //
      //         label: Text((currentPage + 1 ).toString() + "/${pages}" ),
      //         onPressed: () async{
      //           return showDialog(context: context, builder: (context){
      //             return AlertDialog(
      //               // title: Text("Masukan Halaman :"),
      //               content: TextField(
      //                 onChanged: (value){
      //                   setState(() {
      //                     halaman = value as int;
      //                     snapshot.data.setPage(halaman);
      //                   });
      //                 },
      //                 controller: _textFieldController,
      //                 decoration: InputDecoration(hintText: "Masukan Halaman"),
      //               ),
      //               actions: <Widget>[
      //                 FlatButton(onPressed: (){
      //                   setState(() {
      //                     // snapshot.data.setPage(halaman);
      //                   });
      //                 }, child: Text("Cari"))
      //               ],
      //             );
      //           }
      //           );
      //         },
      //         // onPressed: () async {
      //         //   await snapshot.data.setPage(pages ~/ 2);
      //         // },
      //       );
      //     }
      //
      //     return Container();
      //   },
      // ),
    );
  }
}