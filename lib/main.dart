import 'package:flutter/material.dart';
import 'package:plusminus/screen/Game.dart';

void main() {

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoardW(),
    );
  }
}
