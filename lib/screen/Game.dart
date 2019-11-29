import 'package:flutter/material.dart';
import 'package:plusminus/model/board.dart';

class BoardW extends StatelessWidget {
  final board = Board.generate(5);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: board.rowSize,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0),
      itemCount: board.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Text(board[i].toString()),
          color: Colors.teal[100],
        );
      },
    );
  }
}
