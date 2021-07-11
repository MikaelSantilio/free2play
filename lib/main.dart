import 'package:flutter/material.dart';
import 'package:free2play/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Free2Play',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}