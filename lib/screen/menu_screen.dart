import 'package:dartea/dartea.dart';
import 'package:flutter/material.dart';
import 'package:plusminus/domain/menu/menu_tea.dart';
import 'package:plusminus/domain/tea.dart';

import '../router.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProgramWidget(
      init: menuInit,
      update: (msg, model) => menuUpdate(model, msg, Router(context)),
      view: _view,
      withDebugTrace: true,
      withMessagesBus: true,
    );
  }
}

Widget _view(BuildContext ctx, Dispatch<UserAction> dispatch, MenuModel model) {
  print(model);
  final List<Widget> menuItems = model.menus.map((menu) {
    return Center(
      child: RaisedButton(
        child: Text(_menuName(menu)),
        onPressed: () {
          dispatch(MenuMsgTap(menu));
        },
      ),
    );
  }).toList();
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: menuItems,
    ),
  );
}

// ignore: missing_return
String _menuName(Menu menu) {
  switch(menu) {
    case Menu.single:
      return "Single player game";
    case Menu.options:
      return "Settings";
    case Menu.statistics:
      return "Statistics";
    case Menu.policy:
      return "Privacy policy";
  }
}
