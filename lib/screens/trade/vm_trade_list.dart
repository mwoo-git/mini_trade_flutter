import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

class TradeListViewModel extends GetxController {
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  List<BinanceTradeTicker>? trades;

  @override
  void onInit() {
    super.onInit();
  }
}
