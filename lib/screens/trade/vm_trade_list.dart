import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    receiveData();
  }

  void receiveData() async {
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
  }
}
