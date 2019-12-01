
import 'dart:convert';

import 'package:plusminus/model/board.dart';
import 'package:test/test.dart';

void main() {
  test('Board: encode/decode, equals', (){
    final board = Board.generate(5);
    final boardEncoded = json.encode(board.toMap());
    final boardDecoded = Board.fromMap(json.decode(boardEncoded));
    expect(boardDecoded, board);
  });
}