import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/search_delegate.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/w_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/w_refresh_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  get vm => Get.find<CoinListViewModel>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context),
        body: const CoinListView(),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: sortPopupMenuButton,
      title: const Text('바이낸스 선물'),
      actions: [
        showSearchButton(context),
        const RefreshButton(),
      ],
    );
  }

  IconButton showSearchButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: CoinSearchDelegate(vm));
        },
      );

  Widget get sortPopupMenuButton => PopupMenuButton<SortCoins>(
        icon: const Icon(Icons.menu),
        onSelected: (sort) {
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
