import 'package:flutter/material.dart';
import 'package:plusminus/util/common.dart';
import 'dart:math';

int xy2i(int x, int y, int row) => y * row + x;

@immutable
class Board {
  final List<int> cells;
  final int rowSize;
  final int length;

  static Board generate(int rowSize) {
    final cells = List.generate(rowSize * rowSize, (i) => rand.nextInt(19) - 9);
    return Board(cells);
  }

  int operator [](int i) => cells[i];

  XY coords(int i) => XY(x: i % rowSize, y: i ~/ rowSize);

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  Board(this.cells)
      : this.rowSize = sqrt(cells.length).toInt(),
        this.length = cells.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Board &&
          runtimeType == other.runtimeType &&
          cells == other.cells &&
          rowSize == other.rowSize);

  @override
  int get hashCode => cells.hashCode ^ rowSize.hashCode;

  @override
  String toString() {
    return 'Board{' + ' cells: $cells,' + ' rowSize: $rowSize,' + '}';
  }

  Board copyWith({
    List<int> cells,
    int rowSize,
  }) =>
      new Board(cells ?? this.cells);

  Map<String, dynamic> toMap() => {
        'cells': this.cells,
        'row-size': this.rowSize,
      };

  factory Board.fromMap(Map<String, dynamic> map) =>
      new Board(map['cells'] as List<int>);

//</editor-fold>
}

class XY {
  final int x, y;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const XY({
    @required this.x,
    @required this.y,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XY &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'XY{' + ' x: $x,' + ' y: $y,' + '}';
  }

  XY copyWith({
    int x,
    int y,
  }) {
    return new XY(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': this.x,
      'y': this.y,
    };
  }

  factory XY.fromMap(Map<String, dynamic> map) {
    return new XY(
      x: map['x'] as int,
      y: map['y'] as int,
    );
  }

//</editor-fold>
}
