import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mini_trade_flutter/screens/home/w_coin_list.dart';
import 'package:mini_trade_flutter/screens/trade/w_trade_list.dart';
export 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdType {
  coinlist,
  tradelist,
}

class AdHelper {
  static String androidId = 'ca-app-pub-9927157586283098/7020988396';
  static String iosId = 'ca-app-pub-1296116559995152/4078591288';

  static String androidTestId = 'ca-app-pub-3940256099942544/6300978111';
  static String iosTestId = 'ca-app-pub-3940256099942544/2934735716';

  static String testAdUnitId = Platform.isAndroid ? androidTestId : iosTestId;

  static String releaseAdUnitId = Platform.isAndroid ? androidId : iosId;

  static String bannerAdUnitId = kReleaseMode ? releaseAdUnitId : testAdUnitId;

  static BannerAd configureBannerAd(AdType type) {
    final bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          type == AdType.coinlist
              ? CoinListView.onAdLoad.value = true
              : TradeListView.onAdLoad.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          type == AdType.coinlist
              ? CoinListView.onAdLoad.value = false
              : TradeListView.onAdLoad.value = false;
          print('DEBUG: 배너 광고 로드 실패. $error');
        },
      ),
    );

    bannerAd.load();

    return bannerAd;
  }
}
