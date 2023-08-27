import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/data/prefs.dart';
import '../common/w_switch.dart';

class EditColorView extends StatefulWidget {
  const EditColorView({super.key});

  @override
  State<EditColorView> createState() => _EditColorViewState();
}

class _EditColorViewState extends State<EditColorView> {
  @override
  Widget build(BuildContext context) {
    const title = '바이낸스 테마';
    const description = '바이낸스 테마 사용 시 매수는 초록색, 매도는 빨간색으로 보여집니다.';
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            themeChangeTile(context).paddingOnly(bottom: 10),
            const Text(
              description,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ).paddingSymmetric(horizontal: 14));
  }

  Row themeChangeTile(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '바이낸스 테마 사용하기',
            style: TextStyle(fontSize: 16),
          ),
          CustomSwitch(
              value: Prefs.isBinanceTheme.get(),
              onChanged: (value) {
                changeBinanceTheme(value);
              }),
        ],
      );

  void changeBinanceTheme(bool value) {
    setState(() {
      Prefs.isBinanceTheme.set(value);
      Prefs.didBinanceThemeChanged.toggle();
    });
  }
}
