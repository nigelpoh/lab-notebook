import 'package:flutter/material.dart';

class UtilityBarTextBoxKeyboard extends StatelessWidget implements PreferredSizeWidget {
  final FocusNode node;
  final TextEditingController controller;

  const UtilityBarTextBoxKeyboard({
    Key key,
    this.node,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.black 
            ),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alignment",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 10,
                  )
                ),
                Row(
                  children:<Widget>[
                    IconButton(
                      icon: Icon(Icons.format_align_left),
                      onPressed: () => print('hello world 1')
                    ),
                    IconButton(
                      icon: Icon(Icons.format_align_center), 
                      onPressed: () => print(controller.text)
                    ),
                    IconButton(
                      icon: Icon(Icons.format_align_right), onPressed: () => node.unfocus()
                    ),
                    IconButton(
                      icon: Icon(Icons.format_align_justify), onPressed: () => node.unfocus()
                    )
                  ]
                )
              ]
            )
          )
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}