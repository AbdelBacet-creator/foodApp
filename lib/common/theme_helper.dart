
import 'package:flutter/material.dart';

class ThemeHelper{

  InputDecoration textInputDecoration([String lableText="", String hintText = ""]){
    return InputDecoration(
      
      border: OutlineInputBorder(),
      labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
     contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 20,
        offset: const Offset(0, 5),


      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context, [String color1 = "", String color2 = ""]) {
    Color c1 = Color.fromARGB(255, 252, 107, 40);
    Color c2 = Theme.of(context).accentColor;
    if (color1.isEmpty == false) {
      c1 =Colors.orange;
    }
    if (color2.isEmpty == false) {
      c2 = Colors.blue;
    }

    return BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
        colors: [
          c1,
          c2,
        ],
      ),
      color: Colors.deepPurple.shade300,
      borderRadius: BorderRadius.circular(8),

    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
       minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}

class LoginFormStyle{

}
