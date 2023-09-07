import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';
import 'package:mini_trade_flutter/screens/common/w_banner_ad.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';
import 'package:mini_trade_flutter/screens/v_main_tab.dart';
import '../../global/ad/ad_helper.dart';
import '../../global/constant/app_colors.dart';
import '../../global/data/prefs.dart';

class CoinListView extends StatefulWidget {
  const CoinListView({super.key});

  @override
  State<CoinListView> createState() => _CoinListViewState();

  static listTileTabed(String market) {
    BinanceWebSocketService.currentCoin.value = market;
    MainTabViewState.currentIndex.value = 1;
  }
}

class _CoinListViewState extends State<CoinListView> {
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
    final vm = Get.find<CoinListViewModel>();
    return Obx(() {
      if (vm.coinlist.isEmpty) {
        return const ProgressView();
      } else {
        return ListView.builder(
          itemCount: vm.coinlist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // 첫 번째 아이템에 광고를 추가
              return BannerAdWidget(bannerAd: bannerAd).paddingOnly(bottom: 15);
            } else if (index == 1) {
              // 두 번째 아이템에 리스트 헤더를 추가
              return listHeader.paddingOnly(left: 17, right: 21);
            } else {
              // 나머지 리스트 아이템 처리
              final ticker = vm.coinlist[index - 2]; // -2를 해서 올바른 데이터 인덱스로 변환
              return listTileView(ticker, context);
            }
          },
        );
      }
    });
  }

  Row get listHeader => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('심볼 / 거래량'),
          Text('변동률 / 가격'),
        ],
      );

  ListTile listTileView(TickerViewModel ticker, BuildContext context) {
    Color color = AppColors.getTradeColor(ticker.ticker.changeRate);

    return ListTile(
      onTap: () => CoinListView.listTileTabed(ticker.market),
      title: RichText(
        text: TextSpan(
          text: ticker.symbol,
          style: TextStyle(fontSize: 16.0, color: context.appColors.textColor),
          children: const <TextSpan>[
            TextSpan(
              text: ' / USDT',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
      subtitle: Text(ticker.volume),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            ticker.changeRate,
            style: TextStyle(
              color: color,
              fontSize: 14.0,
            ),
          ),
          Text(
            ticker.price,
            style: const TextStyle(
              fontSize: 14.0,
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
