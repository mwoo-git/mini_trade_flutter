import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  final BannerAd bannerAd;

  const BannerAdWidget({super.key, required this.bannerAd});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      child: AdWidget(ad: bannerAd),
    ).paddingSymmetric(horizontal: 15);
  }
}
