import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(LabNotebook());
}

class LabNotebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Lab Notebook Base Prototype v0.1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(), // landing screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File imageFile;
  final picker = ImagePicker();

  _openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  _openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  Future<void> _showPhotoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Image"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera();
                  },
                )
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: new SafeArea(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Colors.grey[400],
                      width: 0.5,
                    )),
                    color: Colors.white),
                width: 48.0,
                height: 48.0,
                child: new Stack(children: <Widget>[
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.title),
                          color: Colors.grey[700],
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_photo_alternate),
                          color: Colors.blue[700],
                          onPressed: () {
                            _showPhotoDialog(context);
                          },
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.gesture),
                          color: Colors.grey[700],
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.table_chart),
                          color: Colors.grey[700],
                          onPressed: () {},
                        )
                      ]),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {},
                        )
                      ])
                ])),
            Container(
                color: Colors.white, height: MediaQuery.of(context).size.height)
          ]))),
    );
  }
}
