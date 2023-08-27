import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

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
