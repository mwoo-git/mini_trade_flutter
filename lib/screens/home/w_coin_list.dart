import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';
import 'package:mini_trade_flutter/screens/common/w_banner_ad.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';
import '../../global/ad/ad_helper.dart';
import '../../global/constant/app_colors.dart';
import '../../global/data/prefs.dart';
import '../trade/w_trade_list.dart';

class BinanceCoinListView extends StatefulWidget {
  const BinanceCoinListView({super.key});

  static Rx<bool> onAdLoad = false.obs;

  @override
  State<BinanceCoinListView> createState() => _BinanceCoinListViewState();

  static listTileTabed(String market) {
    TradeListView.updateView(market);
  }
}

class _BinanceCoinListViewState extends State<BinanceCoinListView> {
  late BannerAd bannerAd;

  @override
  void initState() {
    observer();
    configureBannerAd();
    super.initState();
  }

  configureBannerAd() {
    bannerAd = AdHelper.configureBannerAd(AdType.coinlist);
  }

  observer() {
    ever(Prefs.didBinanceThemeChanged, (value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<CoinListViewModel>();
    return Scaffold(
      body: Obx(() {
        if (vm.coinlist.isEmpty) {
          return const ProgressView();
        } else {
          return RefreshIndicator(
            color: Colors.grey,
            onRefresh: () async {
              HapticFeedback.lightImpact();
              CoinListViewModel.fetchTicker.toggle();
              await Future.delayed(const Duration(seconds: 1));
              HapticFeedback.lightImpact();
            },
            child: SingleChildScrollView(
              child: DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (BinanceCoinListView.onAdLoad.value)
                      //   BannerAdWidget(bannerAd: bannerAd)
                      //       .paddingOnly(bottom: 15),
                      listHeader(context),
                      Expanded(
                          child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: vm.coinlist.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              final ticker = vm.coinlist[index];
                              return listTileView(ticker, context);
                            },
                          ),
                          ListView.builder(
                            itemCount: vm.coinlist.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              final ticker = vm.coinlist[index];
                              return listTileView(ticker, context);
                            },
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  TabBar listHeader(BuildContext context) => TabBar(
        tabAlignment: TabAlignment.start,
        labelStyle: Theme.of(context).textTheme.titleMedium,
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.grey),
        isScrollable: true,
        indicatorColor: context.appColors.textColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        tabs: const [
          Tab(text: "원화"),
          Tab(text: "관심"),
        ],
      );

  ListTile listTileView(TickerViewModel ticker, BuildContext context) {
    Color color = AppColors.getTradeColor(ticker.ticker.changeRate);

    return ListTile(
      onTap: () => BinanceCoinListView.listTileTabed(ticker.market),
      title: RichText(
        text: TextSpan(
          text: ticker.symbol,
          style: TextStyle(
              fontSize: 16.0,
              color: context.appColors.textColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'sans'),
          children: const <TextSpan>[
            TextSpan(
              text: ' / USDT',
              style: TextStyle(
                  fontSize: 12.0, color: Colors.grey, fontFamily: 'sans'),
            ),
          ],
        ),
      ),
      subtitle: Text('Vol ${ticker.volume}',
          style: const TextStyle(
              fontSize: 12.0, color: Colors.grey, fontFamily: 'sans')),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            ticker.changeRate,
            style: TextStyle(
                color: color,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'sans'),
          ),
          Text(
            ticker.price,
            style: const TextStyle(
                fontSize: 12.0, color: Colors.grey, fontFamily: 'sans'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 광고 해제
    bannerAd.dispose();
    super.dispose();
  }
}
