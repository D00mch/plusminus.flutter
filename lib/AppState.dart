import 'package:flutter/material.dart';
import 'package:plusminus/model/game_state.dart';

@immutable
class AppState {

  final GameState state;
  final int currentRowSize;
  final bool isUsrHrz;

  final AlertData alertData;

//<editor-fold desc="Data Methods" defaultstate="collapsed">


  const AppState({
    @required this.state,
    @required this.currentRowSize,
    @required this.isUsrHrz,
    @required this.alertData,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AppState &&
              runtimeType == other.runtimeType &&
              state == other.state &&
              currentRowSize == other.currentRowSize &&
              isUsrHrz == other.isUsrHrz &&
              alertData == other.alertData
          );


  @override
  int get hashCode =>
      state.hashCode ^
      currentRowSize.hashCode ^
      isUsrHrz.hashCode ^
      alertData.hashCode;


  @override
  String toString() {
    return 'AppState{' +
        ' currentState: $state,' +
        ' currentRowSize: $currentRowSize,' +
        ' currentIsHrz: $isUsrHrz,' +
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
      state: currentState ?? this.state,
      currentRowSize: currentRowSize ?? this.currentRowSize,
      isUsrHrz: currentIsHrz ?? this.isUsrHrz,
      alertData: alertData ?? this.alertData,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'currentState': this.state,
      'currentRowSize': this.currentRowSize,
      'currentIsHrz': this.isUsrHrz,
      'alertData': this.alertData,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return new AppState(
      state: map['currentState'] as GameState,
      currentRowSize: map['currentRowSize'] as int,
      isUsrHrz: map['currentIsHrz'] as bool,
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
