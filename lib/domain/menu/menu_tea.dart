import 'package:dartea/dartea.dart';
import 'package:plusminus/data/Storage.dart';
import 'package:plusminus/domain/game/game_tea.dart';
import 'package:plusminus/domain/tea.dart';
import 'package:plusminus/model/game_state.dart';

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
    final cmd = Cmd.ofAsyncAction(() async {
      final menu = msg.menu;
      switch (menu) {
        case Menu.single:
          GModel model = await stateGetSingleGame();
          if (model == null) {
            model = GModel(
              gameType: GameType.single,
              state: GameState.generate(5),
              rowSize: 5,
              isUsrHrz: true,
            );
          }
          router.showSinglePlayerGame(model);
          break;
        case Menu.options:
          throw UnimplementedError();
        case Menu.statistics:
          throw UnimplementedError();
        case Menu.policy:
          router.showPrivacyPolicy();
      }
    });
    return Upd(model, effects: cmd);
  }
  return Upd(model);
}
