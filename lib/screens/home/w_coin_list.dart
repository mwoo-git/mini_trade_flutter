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

class CoinListView extends StatefulWidget {
  const CoinListView({super.key});

  static Rx<bool> onAdLoad = false.obs;

  @override
  State<CoinListView> createState() => _CoinListViewState();

  static listTileTabed(String market) {
    TradeListView.updateView(market);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (CoinListView.onAdLoad.value)
                    BannerAdWidget(bannerAd: bannerAd).paddingOnly(bottom: 15),
                  ListView.builder(
                    itemCount: vm.coinlist.length + 1,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return listHeader.paddingOnly(
                            left: 15, top: 10, bottom: 10);
                      } else {
                        final ticker = vm.coinlist[index - 1];
                        return listTileView(ticker, context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  RichText get listHeader => RichText(
        text: TextSpan(
          text: '바이낸스 선물',
          style: TextStyle(
              fontSize: 20.0,
              color: context.appColors.textColor,
              fontWeight: FontWeight.bold, 
              fontFamily: 'sans'),
          children: const <TextSpan>[
            TextSpan(
              text: '   Perpetual',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
                fontFamily: 'sans'
              ),
            ),
          ],
        ),
      );

  ListTile listTileView(TickerViewModel ticker, BuildContext context) {
    Color color = AppColors.getTradeColor(ticker.ticker.changeRate);

    return ListTile(
      onTap: () => CoinListView.listTileTabed(ticker.market),
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
                fontSize: 12.0,
                color: Colors.grey,
                fontFamily: 'sans'
              ),
            ),
          ],
        ),
      ),
      subtitle: Text('Vol ${ticker.volume}',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
            fontFamily: 'sans'
          )),
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
              fontFamily: 'sans'
            ),
          ),
          Text(
            ticker.price,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'sans'),
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
