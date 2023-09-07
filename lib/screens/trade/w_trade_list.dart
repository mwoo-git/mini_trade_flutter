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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vm = Get.find<TradeListViewModel>();
      return ListView.builder(
        reverse: false,
        itemCount: vm.tradelist.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            // 첫 번째 아이템에 광고를 추가
            return BannerAdWidget(bannerAd: bannerAd).paddingOnly(bottom: 15);
          } else if (index == 1) {
            // 두 번째 아이템에 리스트 헤더를 추가
            return vm.tradelist.isEmpty
                ? const EmptyListView()
                : listHeader.paddingOnly(left: 18, right: 21);
          } else {
            // 나머지 리스트 아이템 처리
            final ticker = vm.tradelist[index - 2];
            return listTileView(ticker);
          }
        },
      );
    });
  }

  Row get listHeader => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 100, child: Text('시간')),
              Text('가격'),
            ],
          ),
          Text('거래대금(USDT)'),
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
              decoration:
                  ticker.amounInt > 100000 ? TextDecoration.underline : null,
              decorationColor: AppColors.getTradeColor(ticker.ticker.trade),
              fontWeight: ticker.amounInt > 100000 ? FontWeight.bold : null,
            ),
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
