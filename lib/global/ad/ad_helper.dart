import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
export 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String androidId = 'ca-app-pub-9927157586283098/7020988396';
  static String iosId = 'ca-app-pub-9927157586283098/5874631523';
  static String androidTestId = 'ca-app-pub-3940256099942544/6300978111';
  static String iosTestId = 'ca-app-pub-3940256099942544/2934735716';

  static String testAdUnitId = Platform.isAndroid ? androidTestId : iosTestId;

  static String releaseAdUnitId = Platform.isAndroid ? androidId : iosId;

  static String bannerAdUnitId = kReleaseMode ? releaseAdUnitId : testAdUnitId;

  static BannerAd configureBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId, // 광고 단위 ID
      size: AdSize.banner, // 광고 크기
      request: const AdRequest(), // 광고 요청
      listener: const BannerAdListener(), // 광고 이벤트 리스너
    );
  }
}
