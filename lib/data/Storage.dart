import 'dart:convert';

import 'package:plusminus/domain/game/game_tea.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _singleGameState = '_singleGameState';

Future<bool> stateSetSingleGame(GModel model) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(_singleGameState, json.encode(model.toMap()));
}

Future<GModel> stateGetSingleGame() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.get(_singleGameState);
}
