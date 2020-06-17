import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:lab_notebook_project_source/visibility_assurance_widget.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lab_notebook_project_source/textbox_keyboard.dart';


class TextBoxInteractive extends StatefulWidget {
  final entireScreenTouchDetector;
  TextBoxInteractive({Key key, @required this.entireScreenTouchDetector}) : super(key: key);
  @override _TextBoxInteractiveState createState() => _TextBoxInteractiveState();
}
class _TextBoxInteractiveState extends State<TextBoxInteractive> {
  Color _color = Colors.black;
  double _fontsize = 15.0;
  double _posx = Offset.zero.dx;
  double _posy = Offset.zero.dy;
  double _widthtfield = 200.0;
  double _heighttfield = 200.0;
  TextAlign _alignmenttfield = TextAlign.left;
  bool _clickedttfield = false;
  FocusNode _focusNodetfield;
  FocusNode _focusNoderotation;
  bool _doubleTapped = false;
  bool _justdoubledTapped = false;
  bool _overflowtfield = false;
  bool _isresizing = false;
  bool _isrotating = false;
  bool _isrotatingpromptactivated = false;
  bool _doubleTappedRotating = false;
  double _rotatedangletfield = 0.0;
  double _calculatedangletfield = 0.0;
  double _yposrotatetfield = 0.0;
  final _rotationTextBoxController = TextEditingController();
  final _textController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _focusNodetfield.dispose();
    _focusNoderotation.dispose();
    _rotationTextBoxController.dispose();
  }
  @override
  void initState() {
    super.initState();
    _focusNodetfield = new FocusNode();
    _focusNoderotation = new FocusNode();
    _focusNodetfield.addListener(_onFocusNodeTfieldEvent);
    _focusNoderotation.addListener(_onFocusNodeRotationEvent);
    _rotationTextBoxController.addListener(_onChangeRotationValueEvent);
  }
  _onFocusNodeTfieldEvent() {
    setState((){
      if(_focusNodetfield.hasFocus == false && _justdoubledTapped == false){
        _doubleTapped = false;
        _clickedttfield = false;
      }else if(_focusNodetfield.hasFocus == false && _justdoubledTapped == true){
        FocusScope.of(context).requestFocus(_focusNodetfield);
      }
      if(_justdoubledTapped == true){
        _justdoubledTapped = false;
      }
    });
  }
  _onFocusNodeRotationEvent(){
    setState(() {
      if(_doubleTappedRotating == true){
        _isrotatingpromptactivated = true;
        _doubleTappedRotating = false;
      }else{
        _isrotatingpromptactivated = false;
      }
      if(_yposrotatetfield == 0){
        _yposrotatetfield = MediaQuery.of(context).size.height * 0.15 * 0.5 + MediaQuery.of(context).viewInsets.bottom;
      }else{
        _yposrotatetfield = 0;
      }
    });
  }
  _onChangeRotationValueEvent(){
    setState(() {
      try{
        if(_rotationTextBoxController.text != ""){
          if(double.parse(_rotationTextBoxController.text) < 0 || double.parse(_rotationTextBoxController.text) > 360){
            _rotationTextBoxController.text = _rotationTextBoxController.text.substring(0, _rotationTextBoxController.text.length - 1);
            _rotationTextBoxController.selection = TextSelection.fromPosition(TextPosition(offset: _rotationTextBoxController.text.length));
          }else{
            _rotatedangletfield = double.parse(_rotationTextBoxController.text) / 360 * (2 * pi);
          }
        }
      }on Exception catch(_){
        _rotationTextBoxController.text = _rotationTextBoxController.text.substring(0, _rotationTextBoxController.text.length - 1);
        _rotationTextBoxController.selection = TextSelection.fromPosition(TextPosition(offset: _rotationTextBoxController.text.length));
      }
    });
  }
  @override
  Widget build(BuildContext context){
    widget.entireScreenTouchDetector.addListener(() {
        _clickedttfield = false;
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          setState(
            () {
              _clickedttfield = true;
            }
          );
        },
        onDoubleTap: (){
          setState(
            (){
              _doubleTapped = true;
              _justdoubledTapped = true;
              _clickedttfield = true;
              FocusScope.of(context).requestFocus(_focusNodetfield);
            }
          );
        },
        onPanUpdate: (details) {
          setState(
            () {
              if(_isresizing == false){
                _posx = _posx + details.delta.dx; 
                _posy = _posy + details.delta.dy;
              }
            }
          );
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: _posx,
              top: _posy,
              child: Wrap(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Transform(
                        alignment: FractionalOffset.center,
                        transform: new Matrix4.rotationZ(_rotatedangletfield),
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: _widthtfield,
                                height: _heighttfield,
                                margin: EdgeInsets.fromLTRB(5, 10 * 1.5, 5, 10 * 0.9), //10 comes from _stateOfButtons()
                                child: DottedBorder(
                                  dashPattern: [2,3],
                                  color: _getTextFieldBorderColor(),
                                  strokeWidth: 1,
                                  child: KeyboardActions(
                                    tapOutsideToDismiss: false,
                                    autoScroll: false,
                                    config: KeyboardActionsConfig(
                                      keyboardSeparatorColor: Colors.purple,
                                      actions: [
                                        KeyboardAction(
                                          focusNode: _focusNodetfield,
                                          displayArrows: false,
                                          displayActionBar: false,
                                          footerBuilder: (context) {
                                            return UtilityBarTextBoxKeyboard(
                                              node: _focusNodetfield,
                                              controller: _textController,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      enabled: _doubleTapped,
                                      cursorColor: Colors.black,
                                      cursorWidth: 1.0,
                                      maxLines: [1, (_heighttfield / _fontsize).floor()].reduce(max),
                                      focusNode: _focusNodetfield,
                                      textAlign: _alignmenttfield,
                                      style: TextStyle(
                                        color: _color,
                                        fontSize: _fontsize
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Text',
                                        hintStyle: TextStyle(fontSize: _fontsize, color: Colors.black),                                                                                                                  
                                      ),
                                      onChanged: (text){
                                        setState(() {
                                          if(((_heighttfield - 10) / (_fontsize + 5)).floor() < ('\n'.allMatches(text).length + 1)){
                                            _overflowtfield = true;
                                          }else{
                                            _overflowtfield = false;
                                          }
                                        });
                                      },
                                      onEditingComplete: (){
                                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                      },
                                      scrollPhysics: NeverScrollableScrollPhysics(),
                                    )
                                  )
                                )
                              ),
                              Positioned(
                                left:_widthtfield/2.1,
                                bottom: 0,
                                child: Opacity(
                                  opacity: _overflowtfield ? 1.0 : 0.0,
                                  child: Container(
                                    width:_stateOfButtons() * 1.8,
                                    height:_stateOfButtons() * 1.8,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                      color: Colors.white
                                    ),
                                    child: Text(
                                      "•••",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15
                                      )
                                    )
                                  )
                                ),
                              ),
                              Positioned(
                                width:_stateOfButtons(),
                                height: _stateOfButtons() * 1.5,
                                left: _widthtfield * 0.5,
                                top: 0,
                                child: GestureDetector(
                                  onPanUpdate: (details){
                                    setState(() {
                                      _isrotating = true;
                                      List<double> _initialvector = [0,_heighttfield * 0.5];
                                      List<double> _currentvector = [details.globalPosition.dx - _widthtfield * 0.5 - _posx, details.globalPosition.dy - _heighttfield * 0.5 - _posy];
                                      double _cosineangle = (_initialvector[0] * _currentvector[0] + _initialvector[1] * _currentvector[1]) / (sqrt(pow(_initialvector[0],2) + pow(_initialvector[1],2)) * sqrt(pow(_currentvector[0],2) + pow(_currentvector[1],2)));
                                      double _midpointx = _widthtfield * 0.5 + _posx;
                                      double _midpointy = _heighttfield * 0.5 + _posy;
                                      if(details.globalPosition.dx > _midpointx && details.globalPosition.dy < _midpointy){
                                        _rotatedangletfield = pi * 0.5 - asin(_cosineangle).abs(); 
                                        _calculatedangletfield = ((_rotatedangletfield / (2 * pi) * 360 * 10).roundToDouble()) / 10;
                                      }else if(details.globalPosition.dx > _midpointx && details.globalPosition.dy > _midpointy){
                                        _rotatedangletfield = pi * 0.5 + asin(_cosineangle).abs();
                                        _calculatedangletfield = ((_rotatedangletfield / (2 * pi) * 360 * 10).roundToDouble()) / 10;
                                      }else if(details.globalPosition.dx < _midpointx && details.globalPosition.dy > _midpointy){
                                        _rotatedangletfield = pi * 1.5 - asin(_cosineangle).abs();
                                        _calculatedangletfield = ((_rotatedangletfield / (2 * pi) * 360 * 10).roundToDouble()) / 10;
                                      }else if(details.globalPosition.dx < _midpointx && details.globalPosition.dy < _midpointy){
                                        _rotatedangletfield = pi * 1.5 + asin(_cosineangle).abs();
                                        _calculatedangletfield = ((_rotatedangletfield / (2 * pi) * 360 * 10).roundToDouble()) / 10;
                                      }
                                    });
                                  },
                                  onPanEnd: (details){
                                    setState(() {
                                      _isrotating = false;
                                    });
                                  },
                                  onDoubleTap: (){
                                    setState(() {
                                      print("Ohio!");
                                      FocusScope.of(context).requestFocus(_focusNoderotation);
                                      _doubleTappedRotating = true;
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width:_stateOfButtons(),
                                        height:_stateOfButtons(),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                        )
                                      ),
                                      Container(
                                        width:_stateOfButtons() * 0.2,
                                        height:_stateOfButtons() * 0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.rectangle
                                        )
                                      ),
                                    ],
                                  )
                                )
                              ),
                              Positioned(
                                width:_stateOfButtons(),
                                height:_stateOfButtons(), 
                                left:0,
                                top:_stateOfButtons(),
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(
                                      () {
                                        _isresizing = true;
                                        if(_widthtfield - details.delta.dx > _fontsize + 20 && _widthtfield - details.delta.dx < MediaQuery.of(context).size.width - 50){
                                          _widthtfield = _widthtfield - details.delta.dx;
                                          _posx = _posx + details.delta.dx;
                                        }
                                        if(_heighttfield - details.delta.dy > _fontsize + 20 && _heighttfield - details.delta.dy < MediaQuery.of(context).size.height - 100){
                                          _heighttfield = _heighttfield - details.delta.dy;
                                          _posy = _posy + details.delta.dy;
                                        }
                                      }
                                    );
                                  },
                                  onPanEnd: (details) {
                                    setState(() {
                                      _isresizing = false;
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:_stateOfButtons(),
                                        height:_stateOfButtons(),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                        )
                                      )
                                    ]
                                  )
                                )
                              ),
                              Positioned(
                                width:_stateOfButtons(),
                                height:_stateOfButtons(), 
                                right:0,
                                top:_stateOfButtons(),
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(
                                      () {
                                        _isresizing = true;
                                        if(_widthtfield + details.delta.dx > _fontsize + 20 && _widthtfield + details.delta.dx < MediaQuery.of(context).size.width - 50){
                                          _widthtfield = _widthtfield + details.delta.dx;
                                        }
                                        if(_heighttfield - details.delta.dy > _fontsize + 20 && _heighttfield - details.delta.dy < MediaQuery.of(context).size.height - 100){
                                          _heighttfield = _heighttfield - details.delta.dy;
                                          _posy = _posy + details.delta.dy;
                                        }
                                      }
                                    );
                                  },
                                  onPanEnd: (details){
                                    setState(() {
                                      _isresizing = false;
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:_stateOfButtons(),
                                        height:_stateOfButtons(),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                        )
                                      )
                                    ]
                                  )
                                )
                              ),
                              Positioned(
                                width:_stateOfButtons(),
                                height:_stateOfButtons(), 
                                right:0,
                                bottom:_stateOfButtons() * 0.4,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(
                                      () {
                                        _isresizing = true;
                                        if(_widthtfield + details.delta.dx > _fontsize + 20 && _widthtfield + details.delta.dx < MediaQuery.of(context).size.width - 50){
                                          _widthtfield = _widthtfield + details.delta.dx;
                                        }
                                        if(_heighttfield + details.delta.dy > _fontsize + 20 && _heighttfield + details.delta.dy < MediaQuery.of(context).size.height - 100){
                                          _heighttfield = _heighttfield + details.delta.dy;
                                        }
                                      }
                                    );
                                  },
                                  onPanEnd: (details) {
                                    setState(() {
                                      _isresizing = false;
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:_stateOfButtons(),
                                        height:_stateOfButtons(),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                        )
                                      )
                                    ]
                                  )
                                )
                              ),
                              Positioned(
                                width:_stateOfButtons(),
                                height:_stateOfButtons(), 
                                left:0,
                                bottom:_stateOfButtons() * 0.4,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(
                                      () {
                                        _isresizing = true;
                                        if(_widthtfield - details.delta.dx > _fontsize + 20 && _widthtfield - details.delta.dx < MediaQuery.of(context).size.width - 50){
                                          _widthtfield = _widthtfield - details.delta.dx;
                                          _posx = _posx + details.delta.dx;
                                        }
                                        if(_heighttfield + details.delta.dy > _fontsize + 20 && _heighttfield + details.delta.dy < MediaQuery.of(context).size.height - 100){
                                          _heighttfield = _heighttfield + details.delta.dy;
                                        }
                                      }
                                    );
                                  },
                                  onPanEnd: (details) {
                                    setState(() {
                                        _isresizing = false;
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:_stateOfButtons(),
                                        height:_stateOfButtons(),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: _stateOfButtonsBorder()),
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                        )
                                      )
                                    ]
                                  )
                                )
                              )
                            ]
                          )
                        ),
                      ),
                      Stack(
                        children:[
                          Container(
                            alignment: Alignment.center,
                            width:_stateOfRotationPrompt() * 5.5,
                            height:_stateOfRotationPrompt() * 3,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 150),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Text(
                              "$_calculatedangletfieldº",
                              style: TextStyle(
                                fontSize: 15,
                                color:Colors.white
                              )
                            )
                          ),
                          Container(
                            alignment: Alignment.center,
                            width:_stateOfResizePromptX() * 0.1,
                            height:_stateOfResizePromptY() * 0.06,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 150),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Text(
                              "Width: ${(_widthtfield * 10).round() / 10}\nHeight: ${(_heighttfield * 10).round() / 10}",
                              style: TextStyle(
                                fontSize: 15,
                                color:Colors.white
                              )
                            )
                          )
                        ]
                      )
                    ],
                  )
                ]
              ) 
            ),
            Positioned(
              left: 0,
              bottom: _yposrotatetfield,
              child: Container(
                width:_setRotationPromptX() + 30,
                height:_setRotationPromptY() * 0.08,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                   top: BorderSide(
                     color: Colors.grey[100],
                     width: 15
                   ),
                   left: BorderSide(
                     color: Colors.grey[100],
                     width: 15
                   ),
                   right: BorderSide(
                     color: Colors.grey[100],
                     width: 15
                   ),
                  )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: _setRotationPromptX(),
                      height: _setRotationPromptY() * 0.3,
                      child: Column(
                        children: <Widget> [
                          EnsureVisibleWhenFocused(
                            focusNode: _focusNoderotation,
                            child: TextField(
                              cursorColor: Colors.black,
                              cursorWidth: 1.0,
                              focusNode: _focusNoderotation,
                              textAlign: _alignmenttfield,
                              keyboardType: TextInputType.number, 
                              style: TextStyle(
                                color: _color,
                                fontSize: _setRotationPromptY() * 0.02
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Angle of Rotation (Degrees)',
                                hintStyle: TextStyle(
                                  fontSize: _setRotationPromptY() * 0.02
                                )
                              ),
                              onEditingComplete: (){
                                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                              },
                              controller: _rotationTextBoxController,
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }  
  Color _getTextFieldBorderColor() {
    return (_focusNodetfield.hasFocus || _clickedttfield == true) ? Colors.grey : Colors.transparent;
  }
  double _stateOfButtons() {
    return (_focusNodetfield.hasFocus || _clickedttfield == true) ? 10.0 : 0.0;
  }
  double _stateOfButtonsBorder(){
    return (_focusNodetfield.hasFocus || _clickedttfield == true) ? 1.0 : 0.0;
  }
  double _stateOfRotationPrompt() {
    return (_isrotating == true) ? 10.0 : 0.0;
  }
  double _setRotationPromptX() {
    return (_isrotatingpromptactivated == true) ? MediaQuery.of(context).size.width - 15 - 15: 0.0;
  }
  double _setRotationPromptY() {
    return (_isrotatingpromptactivated == true) ? MediaQuery.of(context).size.height : 0.0;
  }
  double _stateOfResizePromptX(){
    return (_isresizing == true) ? MediaQuery.of(context).size.width : 0.0;
  }
  double _stateOfResizePromptY(){
    return (_isresizing == true) ? MediaQuery.of(context).size.height : 0.0;
  }
}
