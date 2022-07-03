import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

/// This is the root widget of the Calculator app. In Flutter, there are 2 main
/// types of widgets, Stateful widgets and Stateless widgets. In this case, the
/// root of the app is a Stateless widget, and the reason is based on the type of
/// content displayed to the user. Whenever you extend the StatelessWidget or
/// StatefulWidget class, you have to implement the required
/// [build] method. Note the syntax used for implementing
/// the function.
///
/// The return type for this function is a Widget, and in this case (and often
/// times in most cases) we are retunring a MaterialApp widget. This widget
/// provides a base app that contains a blank screen. In order to change or
/// manipulate what the user sees on the screen, we pass in numerous parameters to
/// the constructor of the widget. Note that different widgets have different
/// parameters, as well as different required and optional parameters.
///
/// To find out more details on a widget or its parameters, please take a look
/// at the Flutter documentation <https://docs.flutter.dev/>.
///
/// The best way to decide between implementing a Stateful or Stateless widget is
/// the content that is shown on the screen. Check if the content displayed by the
/// widget is changing based on some information that is stored internally within
/// the app. If it is, then you most likely need to use a Stateful widget. If not,
/// and the screen remains mostly static, then you most likely need to use a
/// Stateless widget.
///
/// As an example, think of some basic buttons used in a calculator app. They do
/// not change physically when you tap them, so we would implement it as a
/// Stateless widget. Luckily, we dont usually need to implement our own buttons,
/// as the Flutter team has already created several button types (and other common
/// widgets) that can be customized based on the parameters passed.
///
/// In contast, the section where we would show the text for the calculations
/// would constantly change based on the data given as input, as well as the
/// actual calculation done internally.
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

/*
*
* Pro Tip: Check if your IDE supports extensions/plugins and get one that has
* Flutter snippets to make it easier to type boiler plate code, such as the 
* lines for extending a Stateful or Stateless widget. If you're using VSCode,
* I recommend using Awesome Flutter Snippets.
*
*/

/// The main view of the calculator. You could consider it to be the home page
/// of the app. This is a Stateful Widget, given the nature of the widget.
///
/// [createState] calls calls the widget which contains the state for the main
/// widget.
class CalcView extends StatefulWidget {
  const CalcView({Key? key}) : super(key: key);

  @override
  _CalcViewState createState() => _CalcViewState();
}

class _CalcViewState extends State<CalcView> {
  /// Internal state that shows the input of the user, defaults to 0.
  String input = "0";

  /// Internal state that shows the output of the calculation, defaults to empty
  /// string.
  String output = "";

  /// Internal state that is the equation for the calculation being done,
  /// defaults to empty string.
  String equation = "";

  /// [buildButton] returns a custom button, depending on the type of button
  /// being built. We display an Icon of a backspace instead of using the
  /// unicode version of the backspace.
  ///
  /// [text] is the text to display on the button, defaults to empty string.
  /// [color] is the color of the button.
  /// [fontSize] is the size of the text displayed.
  /// [fontColor] is the color fo the text displayed.
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

  /// [calculation] makes the calculations for the app based on the [text]
  /// passed. It strips [text] down to a string that can be interpreted by the
  /// [math_expressions] package.
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
