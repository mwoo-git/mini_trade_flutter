import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/app.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/data/app_preferences.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 방향만 허용
  ]);

  await AppPreferences.init();
  configureGetX();

  runApp(const App());
}

void configureGetX() {
  Get.lazyPut<CoinListViewModel>(() => CoinListViewModel());
  Get.lazyPut<TradeListViewModel>(() => TradeListViewModel());
  Get.lazyPut<BinanceWebSocketService>(() => BinanceWebSocketService());
}
