import 'dart:convert';

import 'package:plusminus/domain/game/game_tea.dart';
import 'package:plusminus/model/game_state.dart';
import 'package:test/test.dart';

void main() {
  test('GModel encode/decode, equals', () {
    final GModel model = GModel(
      gameType: GameType.single,
      state: GameState.generate(5),
      rowSize: 5,
      isUsrHrz: true,
    );
    final modelEncoded = json.encode(model.toMap());
    final modelDecoded = GModel.fromMap(json.decode(modelEncoded));
    expect(modelDecoded, model);
  });
}
