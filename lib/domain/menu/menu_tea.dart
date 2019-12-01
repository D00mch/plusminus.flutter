import 'package:dartea/dartea.dart';
import 'package:plusminus/domain/tea.dart';

import '../../router.dart';

/// **** Init **** ///
Upd<MenuModel, dynamic> menuInit() => Upd(MenuModel(Menu.values));

/// **** Model **** ///
enum Menu { single, options, statistics, policy }

class MenuModel {
  final List<Menu> menus;

  MenuModel(this.menus);

  @override
  String toString() => 'MenuModel{menus: $menus}';
}

/// **** Messages **** ///
class MenuMsgTap implements UserAction {
  final Menu menu;

  MenuMsgTap(this.menu);
}

/// **** Update **** ///
Upd<MenuModel, dynamic> menuUpdate(MenuModel model, msg, Router router) {
  if (msg is MenuMsgTap) {
    return Upd(model, effects: Cmd.ofAction(() {
      Menu menu = msg.menu;
      switch (menu) {
        case Menu.single:
          router.showSinglePlayerGame();
          break;
        case Menu.options:
          throw UnimplementedError();
        case Menu.statistics:
          throw UnimplementedError();
        case Menu.policy:
          throw UnimplementedError();
      }
    }));
  }
  return Upd(model);
}
