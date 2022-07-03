import 'package:flutter/material.dart';
import 'package:tutorial_1/screens/calculator.dart';

/// This is the root of the app. Whenever a Flutter app is ran, the first
/// function that is ran is the [main] function that is located in
/// /lib/main.dart.
///
/// The important thing to remember is to have the [runApp] function called
/// within this main function, so that Flutter knows which widget to use as the
/// root of the app.
///
/// While it is not required, a common method for implementing the root widget
/// is to have it in a separate file and call the widget in the main function,
/// as shown below.
void main() {
  runApp(const Calculator());
}
