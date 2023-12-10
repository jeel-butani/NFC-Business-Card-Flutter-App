import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mu_card/startscreen.dart';

void main() async {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
    title: 'CARD APP',
    theme: ThemeData(primarySwatch: Colors.grey),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StartScreen();
  }

  static of(BuildContext context) {}
}
