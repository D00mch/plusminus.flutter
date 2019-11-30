import 'package:dartea/dartea.dart';
import 'package:flutter/material.dart';
import 'package:plusminus/screen/game_screen.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DarteaMessagesBus(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BoardScreen(),
      ),
    );
  }
}
