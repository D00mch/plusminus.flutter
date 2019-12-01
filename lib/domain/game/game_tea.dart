import 'package:dartea/dartea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plusminus/model/game_state.dart';
import 'package:plusminus/domain/tea.dart';
import 'package:plusminus/util/common.dart';
import 'package:plusminus/domain/game/game.dart';
import 'dart:async';

import '../../router.dart';

/// **** Init **** ///
Upd<GModel, dynamic> gameInit(model) => Upd(model, effects: Cmd.ofMsg(GMsgAfterMove()));

/// **** Model **** ///
enum GameType { single, multi, campaign }

class GModel {
  final GameState state;
  final int rowSize;
  final bool isUsrHrz;
  final GameType gameType;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GModel({
    @required this.state,
    @required this.rowSize,
    @required this.isUsrHrz,
    @required this.gameType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GModel &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          rowSize == other.rowSize &&
          isUsrHrz == other.isUsrHrz &&
          gameType == other.gameType);

  @override
  int get hashCode =>
      state.hashCode ^ rowSize.hashCode ^ isUsrHrz.hashCode ^ gameType.hashCode;

  @override
  String toString() {
    return 'GModel{' +
        ' state: $state,' +
        ' rowSize: $rowSize,' +
        ' isUsrHrz: $isUsrHrz,' +
        ' gameType: $gameType,' +
        '}';
  }

  GModel copyWith({
    GameState state,
    int rowSize,
    bool isUsrHrz,
    GameType gameType,
  }) {
    return new GModel(
      state: state ?? this.state,
      rowSize: rowSize ?? this.rowSize,
      isUsrHrz: isUsrHrz ?? this.isUsrHrz,
      gameType: gameType ?? this.gameType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state': this.state.toMap(),
      'rowSize': this.rowSize,
      'isUsrHrz': this.isUsrHrz,
      'gameType': enumValueToString(this.gameType),
    };
  }

  factory GModel.fromMap(Map<String, dynamic> map) {
    return new GModel(
      state: GameState.fromMap(map['state']),
      rowSize: map['rowSize'] as int,
      isUsrHrz: map['isUsrHrz'] as bool,
      gameType: enumValueFromString(map['gameType'], GameType.values),
    );
  }

//</editor-fold>
}

/// **** Messages **** ///
class GMsgMove {
  final GameState gameState;

  GMsgMove(this.gameState);
}

class GMsgAfterMove {}

class GMsgStartNew {
  final GModel model;

  GMsgStartNew(this.model);

  static GMsgStartNew fromMode(model) {
    return GMsgStartNew(
        model.copyWith(state: GameState.generate(model.rowSize)));
  }
}

class GMsgClose {}

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
    return Upd(msg.model, effects: Cmd.ofMsg(GMsgAfterMove()));
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
      onSuccess: (r) {
        if (r) {
          return GMsgStartNew.fromMode(model);
        } else {
          return null;
        }
      },
    );
    return Upd(model, effects: cmd);
  } else {
    return Upd(model, effects: Cmd.ofMsg(GMsgStartNew.fromMode(model)));
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
