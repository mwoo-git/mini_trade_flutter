import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_trade_flutter/screens/v_main_tab.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();

    observer();
  }

  void observer() async {
    ever(
      BinanceWebSocketService.vm,
      (vm) async {
        if (vm != null) {
          tradelist.insert(0, vm);

          if (vm.amounInt > 50000 && MainTabView.currentIndex.value == 1) {
            await player.stop();
            await player.play(AssetSource('sounds/01.wav'));
          }
        }
        if (tradelist.length > 15) {
          tradelist.removeLast();
        }
      },
    );

    ever(
      BinanceWebSocketService.currentCoin,
      (coin) {
        clearList();
      },
    );

    ever(
      Prefs.didAmountChanged,
      (value) {
        clearList();
      },
    );
  }

  void clearList() {
    tradelist.value = [];
  }
}
