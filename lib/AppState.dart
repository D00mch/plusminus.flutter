import 'package:flutter/material.dart';
import 'package:plusminus/model/game_state.dart';

@immutable
class AppState {

  final GameState currentState;
  final int currentRowSize;
  final bool currentIsHrz;

  final AlertData alertData;

//<editor-fold desc="Data Methods" defaultstate="collapsed">


  const AppState({
    @required this.currentState,
    @required this.currentRowSize,
    @required this.currentIsHrz,
    @required this.alertData,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AppState &&
              runtimeType == other.runtimeType &&
              currentState == other.currentState &&
              currentRowSize == other.currentRowSize &&
              currentIsHrz == other.currentIsHrz &&
              alertData == other.alertData
          );


  @override
  int get hashCode =>
      currentState.hashCode ^
      currentRowSize.hashCode ^
      currentIsHrz.hashCode ^
      alertData.hashCode;


  @override
  String toString() {
    return 'AppState{' +
        ' currentState: $currentState,' +
        ' currentRowSize: $currentRowSize,' +
        ' currentIsHrz: $currentIsHrz,' +
        ' alertData: $alertData,' +
        '}';
  }


  AppState copyWith({
    GameState currentState,
    int currentRowSize,
    bool currentIsHrz,
    AlertData alertData,
  }) {
    return new AppState(
      currentState: currentState ?? this.currentState,
      currentRowSize: currentRowSize ?? this.currentRowSize,
      currentIsHrz: currentIsHrz ?? this.currentIsHrz,
      alertData: alertData ?? this.alertData,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'currentState': this.currentState,
      'currentRowSize': this.currentRowSize,
      'currentIsHrz': this.currentIsHrz,
      'alertData': this.alertData,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return new AppState(
      currentState: map['currentState'] as GameState,
      currentRowSize: map['currentRowSize'] as int,
      currentIsHrz: map['currentIsHrz'] as bool,
      alertData: map['alertData'] as AlertData,
    );
  }


//</editor-fold>
}

@immutable
class AlertData {
  final String text;
  final okAction;

  AlertData({this.text, this.okAction = null});

}
