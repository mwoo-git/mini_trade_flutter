import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/screens/common/w_switch.dart';
import 'package:mini_trade_flutter/screens/settings/v_edit_specific_amount.dart';

class SpecificAmountSettingView extends StatefulWidget {
  const SpecificAmountSettingView({super.key});

  @override
  State<SpecificAmountSettingView> createState() =>
      _SpecificAmountSettingViewState();
}

class _SpecificAmountSettingViewState extends State<SpecificAmountSettingView> {
  @override
  void initState() {
    observer();
    super.initState();
  }

  observer() {
    ever(Prefs.didSpecificAmountChanged, (value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = '특정거래대금 설정';
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            underlineChangeTile(context).paddingOnly(bottom: 10),
            soundChangeTile(context).paddingOnly(bottom: 10),
            vibrateChangeTile(context).paddingOnly(bottom: 10),
            specificAmountTile(context)
          ],
        ).paddingSymmetric(horizontal: 18));
  }

  ListTile specificAmountTile(BuildContext context) {
    final amount = NumberFormat('#,##0').format(Prefs.specificAmount.get());

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: const Text('특정거래대금 조건 설정'),
      subtitle: Text(
        '현재 $amount USDT 이상',
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditSpecificAmountView(),
          ),
        );
      },
    );
  }

  Widget underlineChangeTile(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '밑줄 강조하기',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '특정거래대금 이상이면 밑줄로 강조합니다.',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          CustomSwitch(
              value: Prefs.underline.get(),
              onChanged: (value) {
                setState(() {
                  Prefs.changePrefs(PrefsType.underline, value);
                });
              }),
        ],
      ).paddingOnly(bottom: 10);

  Widget soundChangeTile(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '소리 알림 사용하기',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '특정거래대금 이상이면 알림을 사용합니다.',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          CustomSwitch(
              value: Prefs.sound.get(),
              onChanged: (value) {
                setState(() {
                  Prefs.changePrefs(PrefsType.sound, value);
                });
              }),
        ],
      ).paddingOnly(bottom: 10);

  Widget vibrateChangeTile(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '진동 알림 사용하기',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '매너모드 사용 시 진동 알림을 사용합니다.',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          CustomSwitch(
              value: Prefs.vibrate.get(),
              onChanged: (value) {
                setState(() {
                  Prefs.changePrefs(PrefsType.vibrate, value);
                });
              }),
        ],
      );
}
