import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:mini_trade_flutter/screens/trade/w_empty_list.dart';
import '../../global/ad/ad_helper.dart';
import '../../global/api/binance_socket.dart';
import '../../global/constant/app_colors.dart';
import '../../global/data/prefs.dart';
import '../common/w_banner_ad.dart';
import '../v_main_tab.dart';

class TradeListView extends StatefulWidget {
  const TradeListView({super.key});

  @override
  State<TradeListView> createState() => _TradeListViewState();

  static updateView(String market) {
    BinanceWebSocketService.currentCoin.value = market;
    MainTabView.currentIndex.value = 1;
  }
}

class _TradeListViewState extends State<TradeListView> {
  late BannerAd bannerAd;
  bool useUnderline = Prefs.underline.get();
  int specificAmount = Prefs.specificAmount.get();

  @override
  void initState() {
    observer();
    configureBannerAd();

    super.initState();
  }

  configureBannerAd() {
    bannerAd = AdHelper.configureBannerAd();
    bannerAd.load();
  }

  observer() {
    ever(Prefs.didBinanceThemeChanged, (value) {
      setState(() {});
    });

    ever(Prefs.didUnderlineChanged, (value) {
      setState(() {
        useUnderline = Prefs.underline.get();
      });
    });

    ever(Prefs.didSpecificAmountChanged, (value) {
      setState(() {
        specificAmount = Prefs.specificAmount.get();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vm = Get.find<TradeListViewModel>();
      return SingleChildScrollView(
        child: Column(
          children: [
            BannerAdWidget(bannerAd: bannerAd).paddingOnly(bottom: 15),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              reverse: false,
              itemCount: vm.tradelist.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return vm.tradelist.isEmpty
                      ? const EmptyListView()
                      : listHeader.paddingOnly(left: 18, right: 21);
                } else {
                  final ticker = vm.tradelist[index - 1];
                  return listTileView(ticker);
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Row get listHeader => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 100, child: Text('시간')),
              Text('체결가'),
            ],
          ),
          Text('순간체결량(USDT)'),
        ],
      );

  ListTile listTileView(TradeTileViewModel ticker) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 100, child: Text(ticker.time)),
              Text(ticker.price),
            ],
          ),
          Text(
            ticker.amountStr,
            style: TextStyle(
              color: AppColors.getTradeColor(ticker.ticker.trade),
              decoration: isUnderline(ticker.amounInt)
                  ? TextDecoration.underline
                  : null,
              decorationColor: AppColors.getTradeColor(ticker.ticker.trade),
              fontWeight: isUnderline(ticker.amounInt) ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  bool isUnderline(int amount) {
    if (useUnderline) {
      return amount > specificAmount ? true : false;
    }
    return false;
  }

  @override
  void dispose() {
    // 광고 해제
    bannerAd.dispose();
    super.dispose();
  }
}
