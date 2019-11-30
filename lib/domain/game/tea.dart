import 'package:dartea/dartea.dart';
import 'package:plusminus/model/game_state.dart';
import 'package:plusminus/domain/tea.dart';
import 'package:plusminus/util/common.dart';
import 'package:plusminus/domain/game/game.dart';
import 'dart:async';

import '../../router.dart';

/// **** Init **** ///
Upd<GModel, dynamic> gameInit() => Upd(
    GModel(
      gameType: GameType.single,
      state: GameState.generate(5),
      rowSize: 5,
      isUsrHrz: true,
    ),
    effects: Cmd.ofMsg(GMsgAfterMove()));

/// **** Model **** ///
enum GameType { single, multi, campaign }

class GModel {
  final GameState state;
  final int rowSize;
  final bool isUsrHrz;
  final GameType gameType;

  GModel({this.gameType, this.state, this.rowSize, this.isUsrHrz});

  GModel copyWith({
    GameState state,
    int rowSize,
    bool isUsrHrz,
    bool GameType,
  }) {
    return new GModel(
      state: state ?? this.state,
      rowSize: rowSize ?? this.rowSize,
      isUsrHrz: isUsrHrz ?? this.isUsrHrz,
      gameType: GameType ?? this.gameType,
    );
  }
}

/// **** Messages **** ///
class GMsgMove {
  final GameState gameState;

  GMsgMove(this.gameState);
}

class GMsgAfterMove {}

class GMsgStartNew {}

class GMsgRequestNew implements UserAction {}

class GMsgTapOnBoard implements UserAction {
  final int move;

  GMsgTapOnBoard(this.move);
}

/// **** Update **** ///

Upd<GModel, dynamic> gameUpdate(GModel model, msg, Router router) {
  if (msg is GMsgTapOnBoard) {
    return _updateOnTap(model, msg, router);
  } else if (msg is GMsgMove) {
    return Upd(
      model.copyWith(state: msg.gameState),
      effects: Cmd.ofMsg(GMsgAfterMove()),
    );
  } else if (msg is GMsgRequestNew) {
    return _updateOnNewGame(model, msg, router);
  } else if (msg is GMsgStartNew) {
    return Upd(
      model.copyWith(state: GameState.generate(model.rowSize)),
      effects: Cmd.ofMsg(GMsgAfterMove()),
    );
  } else if (msg is GMsgAfterMove) {
    final GameType gameType = model.gameType;
    if (gameType == GameType.single) {
      return _updateAfterMove(model, msg, router, _updateBotMove);
    } else {
      throw UnimplementedError("not implemented yet");
    }
  }

  return Upd(model);
}

Upd<GModel, dynamic> _updateOnNewGame(GModel model, msg, Router router) {
  if (model.state.anyMoves()) {
    final cmd = Cmd.ofAsyncFunc(
      () => router.showConfirmationDialog("Start new game?", "You will lose"),
      onSuccess: (r) => r ? GMsgStartNew() : null,
    );
    return Upd(model, effects: cmd);
  } else {
    return Upd(model, effects: Cmd.ofMsg(GMsgStartNew()));
  }
}

Upd<GModel, dynamic> _updateOnTap(
    GModel model, GMsgTapOnBoard msg, Router router) {
  if (model.isUsrHrz != model.state.isHrzTurn) {
    return Upd(model,
        effects: Cmd.ofAction(() => router.showToast("Not your turn")));
  } else if (!model.state.isValidMove(msg.move)) {
    return Upd(model,
        effects: Cmd.ofAction(() => router.showToast("Invalid move")));
  } else {
    final newState = model.state.move(msg.move);
    return Upd(model, effects: Cmd.ofMsg(GMsgMove(newState)));
  }
}

Upd<GModel, dynamic> _updateBotMove(GModel model, msg, Router router) =>
    Upd(model,
        effects: Cmd.ofAsyncFunc(() async {
          final gameState = model.state;
          final int additionalWait = gameState.isStart ? 1000 : 0;
          final int wait = 600 + rand.nextInt(1000) + additionalWait;
          await Future.delayed(Duration(milliseconds: wait));
          return moveBot(gameState);
        }, onSuccess: (GameState st) => GMsgMove(st)));

Upd<GModel, dynamic> _updateAfterMove(
  GModel model,
  GMsgAfterMove msg,
  Router router,
  UpdF<GModel, dynamic> heMoves,
) {
  final gameState = model.state;
  final isEnd = !gameState.anyMoves();
  final isBotMove = model.isUsrHrz != gameState.isHrzTurn;
  if (isEnd) {
    String msg = resultMessage(gameState, model);
    return Upd(model, effects: Cmd.ofAction(() => router.showToast(msg)));
  } else if (isBotMove) {
    return heMoves(model, msg, router);
  } else {
    return Upd(model);
  }
}
