
import 'dart:convert';

import 'package:plusminus/model/game_state.dart';
import 'package:test/test.dart';

void main() {
  test('GameState: encode/decode, equals', (){
    final GameState state = GameState.generate(5);
    final stateEncoded = json.encode(state.toMap());
    final stateDecoded = GameState.fromMap(json.decode(stateEncoded));
    expect(stateDecoded, state);
  });
}
