import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // receiveData();
  }

  void receiveData() async {
    ever(
      socket.data,
      (data) async {
        final ticker = await compute(parseTicker, data);

        final amount = (double.tryParse(ticker.price ?? '0') ?? 0) *
            (double.tryParse(ticker.quantity ?? '0') ?? 0);

        if (amount > 1000) {
          final tradeTileViewModel = TradeTileViewModel(ticker: ticker);
          tradelist.insert(0, tradeTileViewModel);
        }
      },
    );
  }

  Future<BinanceTradeTicker> parseTicker(dynamic data) async {
    final decoded = json.decode(data) as Map<String, dynamic>;
    return BinanceTradeTicker.fromJson(decoded);
  }
}
