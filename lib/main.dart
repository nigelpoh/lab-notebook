import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lab_notebook_project_source/interactable_textbox.dart';
void main() {
  runApp(LabNotebook());
}

class TappedOutside with ChangeNotifier{
  int tappedTimes = 0;
  bool setToFalse = false;
  void changeTapped(){
    tappedTimes++;
    notifyListeners();
  }
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
      home: ChangeNotifierProvider<TappedOutside>(
        create: (context) => TappedOutside(),
        child: MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final counterChangesTapped = Provider.of<TappedOutside>(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (TapUpDetails details) {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            counterChangesTapped.changeTapped();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[400],
                              width: 0.5,
                            )
                          ),
                          color: Colors.white
                        ),
                        width: 48.0,
                        height: 48.0,
                        child: new Stack( 
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:<Widget>[
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
                                  color: Colors.grey[700],
                                  onPressed: () {},
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
                              ]
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  color: Colors.black,
                                  onPressed: () {},
                                )
                              ]
                            )
                          ]
                        )
                      ),
                      TextBoxInteractive(
                        entireScreenTouchDetector: counterChangesTapped,
                      )
                    ]
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}