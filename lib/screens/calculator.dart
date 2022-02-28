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
      title: "Calculator",
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
      padding: const EdgeInsets.all(5),
      child: TextButton(
        onPressed: () => calculation(text),
        child: text == "\u232B"
            ? Icon(
                Icons.backspace_outlined,
                color: fontColor,
                size: 30.0,
              )
            : Text(
                text,
                style: TextStyle(color: fontColor, fontSize: 25),
              ),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
      ),
    );
  }

  calculation(String text) {
    setState(() {
      switch (text) {
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
            input = output + text;
          } else if (input == "0") {
            input = text;
          } else {
            input += text;
          }
          break;
        case "+/-":
          if (int.tryParse(input[input.length - 1]) != null) {
            int index = input.lastIndexOf(RegExp(r"\+|-|\u00F7|\u00D7"));
            if (int.tryParse(input[index - 1]) != null) {
              switch (input[index]) {
                case "+":
                  input = input.replaceRange(
                      index, input.length, "-${input.substring(index + 1)}");
                  break;
                case "-":
                  input = input.replaceRange(
                      index, input.length, "+${input.substring(index + 1)}");
                  break;
                case "\u00F7":
                  input = input.replaceRange(index + 1, input.length,
                      "-${input.substring(index + 1)}");
                  break;
                case "\u00D7":
                  input = input.replaceRange(index + 1, input.length,
                      "-${input.substring(index + 1)}");
                  break;
              }
            } else {
              switch (input[index]) {
                case "+":
                  input = input.replaceRange(
                      index, input.length, "-${input.substring(index + 1)}");
                  break;
                case "-":
                  input = input.replaceRange(
                      index, input.length, input.substring(index + 1));
                  break;
              }
            }
          }
          break;
        default:
          if (output.isNotEmpty) {
            if (int.tryParse(input[input.length - 1]) == null) {
              input += text;
              output = "";
            } else {
              input = text;
              output = "";
            }
          } else if (input == "0") {
            input = text;
          } else {
            input += text;
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
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              input,
              style: const TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(15.0),
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
