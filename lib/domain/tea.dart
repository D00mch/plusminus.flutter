import 'package:dartea/dartea.dart';
import '../router.dart';

/// **** Messages **** ////
abstract class UserAction {}

/// **** Update **** ////
typedef UpdF<Model, Msg> = Upd<Model, dynamic> Function(
    Model model,
    Msg msg,
    Router router,
);
