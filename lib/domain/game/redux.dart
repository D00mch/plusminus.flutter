import 'package:plusminus/model/game_state.dart';
import 'package:plusminus/AppState.dart';
import 'package:plusminus/domain/redux.dart';
import 'package:plusminus/util/common.dart';
import 'package:plusminus/domain/game/game.dart';
import "package:redux/redux.dart";
import 'dart:async';

import '../../AppState.dart';

// ACTIONS
class GameActionMove {
  final GameState gameState;

  GameActionMove(this.gameState);
}

class GameActionOnUpdate {}

class GameActionStartNew {}

class GameActionRequestNew extends UserAction {}

class GameActionTapOnBoard extends UserAction {
  final int move;

  GameActionTapOnBoard(this.move);
}

// MIDDLEWARE

final List<Middleware<AppState>> singleGameMiddleWare = [
  TypedMiddleware<AppState, GameActionTapOnBoard>(_onTapOnBoard()),
  TypedMiddleware<AppState, GameActionRequestNew>(_onRequestNewGame()),
  TypedMiddleware<AppState, GameActionOnUpdate>(_onUpdate()),
];

void Function(
  Store<AppState> store,
  GameActionRequestNew action,
  NextDispatcher next,
) _onRequestNewGame() {
  return (store, action, next) async {
    final appState = store.state;
    final gameState = appState.currentState;

    if (gameState.anyMoves()) {
      store.dispatch(CommonActionAlert(AlertData(
        text: "You will lose if you start new game",
        okAction: GameActionStartNew(),
      )));
    } else {
      store.dispatch(GameActionStartNew());
    }

    next(action);
  };
}

void Function(
  Store<AppState> store,
  GameActionTapOnBoard action,
  NextDispatcher next,
) _onTapOnBoard() {
  return (store, action, next) async {
    final appState = store.state;
    final gameState = appState.currentState;

    if (appState.currentIsHrz == appState.currentState.isHrzTurn) {
      final isValid = appState.currentState.isValidMove(action.move);
      if (isValid) {
        store.dispatch(GameActionMove(gameState.move(action.move)));
      } else {
        store.dispatch(CommonActionAlert(AlertData(text: "Invalid move")));
      }
    } else {
      store.dispatch(CommonActionAlert(AlertData(text: "Not your turn")));
    }
    next(action);
  };
}

void Function(
  Store<AppState> store,
  GameActionOnUpdate action,
  NextDispatcher next,
) _onUpdate() {
  return (store, action, next) async {
    final state = store.state;
    final gameState = state.currentState;

    final isEnd = !gameState.anyMoves();
    final isBotMove = state.currentIsHrz != state.currentState.isHrzTurn;
    if (isEnd) {
      String msg = resultMessage(gameState, state);
      store.dispatch(CommonActionAlert(AlertData(text: msg)));
    } else if (isBotMove) {
      final int additionalWait = gameState.isStart ? 1000 : 0;
      await Future.delayed(
          Duration(milliseconds: 600 + rand.nextInt(1000) + additionalWait));
      store.dispatch(GameActionMove(moveBot(gameState)));
    }
    next(action);
  };
}

String resultMessage(GameState gameState, AppState appState) {
  final result = onGameEng(gameState, appState.currentIsHrz);
  if (result == Result.LOSE) {
    return "You lose";
  } else if (result == Result.WIN) {
    return "You win";
  } else {
    return "Draw";
  }
}

// REDUCER
AppState _reducer(AppState state, action) {
  if (action is GameActionStartNew) {
    final int rowSize = state.currentRowSize;
    return state.copyWith(currentState: GameState.generate(rowSize));
  } else if (action is GameActionMove) {
    return state.copyWith(currentState: action.gameState);
  }
  return state;
}
