import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/app.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CoinListViewModel());
  runApp(const App());
}
