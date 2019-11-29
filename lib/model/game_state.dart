import 'package:flutter/material.dart';
import 'package:plusminus/model/board.dart';
import 'package:plusminus/util/common.dart';

@immutable
class GameState {
  final Board board;
  final int start;
  final int hrzPoints;
  final int vrtPoints;
  final bool isHrzTurn;
  final List<int> moves;

  // calculated
  final List<int> validMoves;
  final int length;
  final bool isStart;

  static GameState generate(int rowSize) => GameState(
      board: Board.generate(rowSize),
      start: rand.nextInt(rowSize),
      hrzPoints: 0,
      vrtPoints: 0,
      isHrzTurn: rand.nextBool());

  int rowsCount() => board.rowSize;

  bool isValidMove(int i) => validMoves.contains(i); // max length is 64

  GameState move(int i) => this.copyWith(
        moves: List.from(moves)..add(i),
        isHrzTurn: !this.isHrzTurn,
        hrzPoints: this.isHrzTurn ? hrzPoints + board[i] : hrzPoints,
        vrtPoints: this.isHrzTurn ? vrtPoints : vrtPoints + board[i],
      );

  int moveVal(int i) => board[i];

  bool anyMoves() => validMoves.isNotEmpty;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  GameState({
    @required this.board,
    @required this.start,
    @required this.hrzPoints,
    @required this.vrtPoints,
    @required this.isHrzTurn,
    this.moves = const [],
  })  : validMoves = _calcValidMoves(moves, start, isHrzTurn, board),
        length = board.length,
        isStart = moves.isEmpty;

  static _calcValidMoves(moves, start, isHrzTurn, board) {
    final int lastMove = moves.isEmpty ? start : moves.last;
    final XY p = board.coords(lastMove);
    final int x = p.x;
    final int y = p.y;
    return List.generate(
      board.rowSize,
      (i) => isHrzTurn ? XY(x: i, y: y) : XY(x: x, y: i),
    )
        .map((p) => xy2i(p.x, p.y, board.rowSize))
        .where((idx) => moves.contains(idx));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameState &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          start == other.start &&
          hrzPoints == other.hrzPoints &&
          vrtPoints == other.vrtPoints &&
          isHrzTurn == other.isHrzTurn &&
          moves == other.moves);

  @override
  int get hashCode =>
      board.hashCode ^
      start.hashCode ^
      hrzPoints.hashCode ^
      vrtPoints.hashCode ^
      isHrzTurn.hashCode ^
      moves.hashCode;

  @override
  String toString() {
    return 'State{' +
        ' board: $board,' +
        ' start: $start,' +
        ' hrzPoints: $hrzPoints,' +
        ' vrtPoints: $vrtPoints,' +
        ' isHrzTurn: $isHrzTurn,' +
        ' moves: $moves,' +
        '}';
  }

  GameState copyWith({
    Board board,
    int start,
    int hrzPoints,
    int vrtPoints,
    bool isHrzTurn,
    List<int> moves,
  }) {
    return new GameState(
      board: board ?? this.board,
      start: start ?? this.start,
      hrzPoints: hrzPoints ?? this.hrzPoints,
      vrtPoints: vrtPoints ?? this.vrtPoints,
      isHrzTurn: isHrzTurn ?? this.isHrzTurn,
      moves: moves ?? this.moves,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'board': this.board,
      'start': this.start,
      'hrz-points': this.hrzPoints,
      'vrt-points': this.vrtPoints,
      'hrz-turn': this.isHrzTurn,
      'moves': this.moves,
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    return new GameState(
      board: map['board'] as Board,
      start: map['start'] as int,
      hrzPoints: map['hrz-points'] as int,
      vrtPoints: map['vrt-points'] as int,
      isHrzTurn: map['hrz-turn'] as bool,
      moves: map['moves'] as List<int>,
    );
  }

//</editor-fold>
}
