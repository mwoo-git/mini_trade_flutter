import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_rest.dart';
import 'package:mini_trade_flutter/global/dart/extension/snackbar_extension.dart';
import 'trade/v_trade.dart';
import 'home/v_home.dart';

class MainTabView extends StatelessWidget {
  MainTabView({super.key});

  late final List<Widget> _tabs = [
    const HomeView(),
    const TradeView(),
  ];

  static RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    observer(context);

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: currentIndex.value,
            children: _tabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) {
              currentIndex.value = index;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Trade',
              ),
            ],
          ),
        ));
  }

  observer(BuildContext context) {
    ever(BinanceRestService.apiStatus, (value) {
      if (value == ApiStatus.restApiError) {
        context.showSnackbar('바이낸스 정보를 받아오지 못 했습니다.');
        BinanceRestService.apiStatus.value = ApiStatus.none;
      }
    });
  }

}

