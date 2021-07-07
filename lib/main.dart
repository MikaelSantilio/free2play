import 'package:flutter/material.dart';
import 'package:free2play/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free2Play',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}