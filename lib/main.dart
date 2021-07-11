import 'package:flutter/material.dart';
import 'package:free2play/screens/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Free2Play',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}