import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'screens/v_main_tab.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    configureGetX();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MainTabView(),
    );
  }

  void configureGetX() {
    Get.lazyPut<CoinListViewModel>(() => CoinListViewModel());
  }
}
