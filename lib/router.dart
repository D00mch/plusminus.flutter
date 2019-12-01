import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plusminus/screen/game_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Router {
  final NavigatorState _navigator;
  final BuildContext _context;

  Router(this._context) : _navigator = Navigator.of(_context);

  void showSinglePlayerGame() {
    _navigator.push(MaterialPageRoute(builder: (_) => GameScreen()));
  }

  void showPrivacyPolicy() {
    _navigator.push(MaterialPageRoute(
        builder: (_) =>
            WebView(initialUrl: "https://plusminus.me/privacy-policy")));
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<bool> showConfirmationDialog(
    String title,
    String body,
  ) =>
      showDialog(
          context: _context,
          builder: (c) {
            return AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => _navigator.pop(true),
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => _navigator.pop(false),
                )
              ],
            );
          });

  void back() {
    _navigator.pop();
  }
}
