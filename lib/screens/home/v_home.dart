import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_rest.dart';
import 'package:mini_trade_flutter/screens/home/search_delegate.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/w_api_error.dart';
import 'package:mini_trade_flutter/screens/home/w_coin_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  get vm => Get.find<CoinListViewModel>();

  var selectedSort = SortCoins.volume;

  RestApiStatus apiStatus = RestApiStatus.none;

  @override
  void initState() {
    observer();
    super.initState();
  }

  observer() {
    ever(BinanceRestService.apiStatus, (value) {
      setState(() {
        apiStatus = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context),
        body: apiStatus == RestApiStatus.error ? const ApiErrorView() : const CoinListView(),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: sortPopupMenuButton,
      title: Text(
        '미니체결',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        showSearchButton(context),
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
