import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const CalcView(),
    );
  }
}

class CalcView extends StatefulWidget {
  const CalcView({Key? key}) : super(key: key);

  @override
  _CalcViewState createState() => _CalcViewState();
}

class _CalcViewState extends State<CalcView> {
  String input = "0";
  String output = "";
  String equation = "";

  Container buildButton(
      {String text = "", Color? color, double? fontSize, Color? fontColor}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          )),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: () => calculation(text),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            text == "\u232B"
                ? Icon(
                    Icons.backspace_outlined,
                    color: fontColor,
                    size: 35.0,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: fontColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void calculation(String button) {
    setState(() {
      switch (button) {
        case "C":
          input = "0";
          output = "";
          equation = "";
          break;
        case "\u232B":
          if (output.isNotEmpty) {
            input = "0";
            output = "";
            equation = "";
          } else {
            input = input.substring(0, input.length - 1);
            if (input == "") {
              input = "0";
            }
          }
          break;
        case "+/-":
          break;
        case "\u003D":
          equation = input;
          equation = equation.replaceAll("\u00F7", "/");
          equation = equation.replaceAll("\u00D7", "*");
          try {
            Parser p = Parser();
            Expression exp = p.parse(equation);
            ContextModel cm = ContextModel();
            output = "${exp.evaluate(EvaluationType.REAL, cm)}";
          } catch (e) {
            output = "Error";
          }
          break;
        case "\u00F7":
        case "\u00D7":
        case "-":
        case "+":
        case "^":
          if (output.isNotEmpty) {
            input = output + button;
            output = "";
          } else if (input == "0") {
            input = button;
          } else {
            input += button;
          }
          break;
        default:
          if (output.isNotEmpty) {
            input = button;
            output = "";
          } else if (input == "0") {
            input = button;
          } else {
            input += button;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculator",
          style: TextStyle(
            fontSize: 35.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            child: Text(
              input,
              style: const TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            child: Text(
              output,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.grey,
              ),
            ),
          ),
          const Expanded(child: Divider()),
          Table(
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  buildButton(
                      color: Colors.red,
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "C"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.red,
                      fontSize: 30.0,
                      text: "\u232B"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.green,
                      fontSize: 30.0,
                      text: "^"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.green,
                      fontSize: 30.0,
                      text: "\u00F7"),
                ],
              ),
              TableRow(
                children: <Widget>[
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "7"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "8"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "9"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.green,
                      fontSize: 30.0,
                      text: "\u00D7"),
                ],
              ),
              TableRow(
                children: <Widget>[
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "4"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "5"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "6"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.green,
                      fontSize: 30.0,
                      text: "-"),
                ],
              ),
              TableRow(
                children: <Widget>[
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "1"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "2"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "3"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.green,
                      fontSize: 30.0,
                      text: "+"),
                ],
              ),
              TableRow(
                children: <Widget>[
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "+/-"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "0"),
                  buildButton(
                      color: Colors.grey[800],
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "."),
                  buildButton(
                      color: Colors.green,
                      fontColor: Colors.white,
                      fontSize: 30.0,
                      text: "\u003D"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
