import 'package:dartea/dartea.dart';
import 'package:flutter/material.dart';
import 'package:plusminus/domain/game/tea.dart';
import 'package:plusminus/domain/tea.dart';
import 'package:plusminus/model/board.dart';
import 'package:plusminus/model/game_state.dart';

import '../router.dart';

class BoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProgramWidget(
        init: () => gameInit(),
        update: (msg, model) => gameUpdate(model, msg, Router(context)),
        view: _view,
        withDebugTrace: true);
  }
}

Widget _view(BuildContext ctx, Dispatch<UserAction> dispatch, GModel model) {
  return Scaffold(
    appBar: AppBar(
      title: Text("plusminus"),
    ),
    body: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _pointsIndicatorWidget(model, true),
              _pointsIndicatorWidget(model, false),
            ],
          ),
          Expanded(child: _boardWidget(ctx, model.state, dispatch)),
          Container(
            padding: EdgeInsets.all(16.0),
            child: RaisedButton(
                onPressed: () => dispatch(GMsgRequestNew()),
                child: Text("new game")),
          ),
        ],
      ),
    ),
  );
}

Widget _pointsIndicatorWidget(GModel model, bool you) {
  String name = "";
  int points;
  final state = model.state;
  if (you) {
    points = model.isUsrHrz ? state.hrzPoints : state.vrtPoints;
    name = "You";
  } else {
    points = model.isUsrHrz ? state.vrtPoints : state.hrzPoints;
    name = "He";
  }
  return Container(child: Text("$name: $points"));
}

Widget _boardWidget(ctx, GameState state, Dispatch<UserAction> dispatch) {
  final Board board = state.board;
  return GridView.builder(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: board.rowSize,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0),
    itemCount: board.length,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, i) => _cellWidget(context, i, state, dispatch),
  );
}

Widget _cellWidget(ctx, i, GameState state, Dispatch<UserAction> dispatch) {
  final board = state.board;
  final valid = state.isValidMove(i);
  final hidden = state.moves.contains(i);
  final userTurn = valid && state.isHrzTurn;
  return Visibility(
    maintainAnimation: true,
    maintainState: true,
    maintainSize: true,
    visible: !hidden,
    child: Container(
        child: FlatButton(
          color: _cellColor(valid, userTurn),
          child: Text(board[i].toString()),
          onPressed: () {
            dispatch(GMsgTapOnBoard(i));
          },
        ),
        color: Colors.teal[100]),
  );
}

Color _cellColor(bool valid, bool userTurn) {
  if (valid && userTurn) {
    return Colors.blue;
  } else if (valid) {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}
