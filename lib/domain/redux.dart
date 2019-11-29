import 'package:redux/redux.dart';

import '../AppState.dart';

// ACTION

abstract class UserAction {}

class CommonActionAlert {
  final AlertData message;

  CommonActionAlert(this.message);
}

// MIDDLEWARE

typedef MiddlewareF<T> = void Function(
    Store<AppState> store, T action, NextDispatcher nextDispatcher);
