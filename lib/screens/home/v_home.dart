import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/w_coin_list.dart';
import 'package:flutter/cupertino.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const CoinListView(),
    );
  }

  PreferredSizeWidget get appBar => AppBar(
        leading: sortPopupMenuButton,
        title: const Text('바이낸스 선물'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('검색 탭!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          )
        ],
      );

  Widget get sortPopupMenuButton => PopupMenuButton<SortCoins>(
        icon: const Icon(Icons.menu),
        onSelected: (sort) {
          final vm = Get.find<CoinListViewModel>();
          vm.updateSortOption(sort);
        },
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SortCoins>>[
          const PopupMenuItem<SortCoins>(
            value: SortCoins.volume,
            child: Text('거래량'),
          ),
          const PopupMenuItem<SortCoins>(
            value: SortCoins.rise,
            child: Text('상승'),
          ),
          const PopupMenuItem<SortCoins>(
            value: SortCoins.fall,
            child: Text('하락'),
          ),
        ],
      );
}
