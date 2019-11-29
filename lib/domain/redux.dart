import '../AppState.dart';

abstract class UserAction {}

class CommonActionAlert {
  final AlertData message;

  CommonActionAlert(this.message);
}
