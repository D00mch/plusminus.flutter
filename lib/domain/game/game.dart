import 'package:collection/collection.dart';
import 'package:plusminus/domain/game/tea.dart';
import 'package:plusminus/model/game_state.dart';

/// **** Bot moves **** ///

GameState predict(GameState state, int turnsAhead) {
  if (!state.anyMoves()) {
    return state.copyWith(isHrzTurn: !state.isHrzTurn);
  } else if (turnsAhead <= 0) {
    return _moveMax(state);
  } else {
    Iterable<GameState> it = state.validMoves
        .map((mv) => state.move(mv))
        .map((st) => predict(state, turnsAhead - 1));
    return maxBy(it, (st) => _pointsDiff(state.isHrzTurn, state));
  }
}

GameState moveBotSafe(GameState state, {int prediction = 3}) {
  final List<GameState> states = _scenarios(state, prediction)
    ..sort(_statesComparator(state.isHrzTurn));
  final List<int> pmvs = states.first.moves;
  final int mv = pmvs[state.moves.length];
  return state.move(mv);
}

GameState moveBot(GameState state, {int prediction = 3}) {
  final List<int> pmvs = predict(state, prediction).moves;
  final int mv = pmvs[state.moves.length];
  return state.move(mv);
}

/// **** Game results **** ///

enum Result { WIN, LOSE, DRAW }

Result resultCalculate(GameState state, bool isUsrHrz) {
  final int hrzP = state.hrzPoints;
  final int vrtP = state.vrtPoints;
  if (hrzP == vrtP) {
    return Result.DRAW;
  } else {
    final hrzWins = hrzP > vrtP;
    return hrzWins == isUsrHrz ? Result.WIN : Result.LOSE;
  }
}

String resultMessage(GameState gameState, GModel appState) {
  final r = resultCalculate(gameState, appState.isUsrHrz);
  if (r == Result.LOSE) {
    return "You lose";
  } else if (r == Result.WIN) {
    return "You win";
  } else {
    return "Draw";
  }
}

/// **** implementation **** ///

GameState _moveMax(GameState state) {
  int maxMove = maxBy(state.validMoves, (e) => state.moveVal(e));
  return state.move(maxMove);
}

int _pointsDiff(bool isHrzTurn, GameState state) {
  final int diff = state.hrzPoints - state.vrtPoints;
  return isHrzTurn ? diff : -diff;
}

List<GameState> _scenarios(GameState state, int turnsAhead) => state.validMoves
    .map((mv) => state.move(mv))
    .map((st) => predict(state, turnsAhead - 1));

Comparator<GameState> _statesComparator(bool isHrzTurn) => (s1, s2) {
      final int m1 = s1.moves.length;
      final int m2 = s2.moves.length;
      final int d1 = _pointsDiff(isHrzTurn, s1);
      final int d2 = _pointsDiff(isHrzTurn, s2);
      final int n = m1 - m2;
      if (0 < d1 && 0 < d2) {
        return n == 0 ? d2 - d1 : n;
      } else {
        return d2 - d1;
      }
    };
