import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/app.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureGetX();
  runApp(const App());
}

void configureGetX() {
  Get.lazyPut<CoinListViewModel>(() => CoinListViewModel());
  Get.lazyPut<TradeListViewModel>(() => TradeListViewModel());
  Get.lazyPut<BinanceWebSocketService>(() => BinanceWebSocketService());
}
