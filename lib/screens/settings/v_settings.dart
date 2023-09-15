import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/screens/settings/v_specific_amount_settings.dart';
import '../../global/data/prefs.dart';
import '../common/w_switch.dart';
import 'v_edit_amount.dart';
import 'v_edit_color.dart';

import '../../global/theme/theme_util.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    observer();
    super.initState();
  }

  observer() {
    ever(Prefs.didAmountChanged, (i) {
      setState(() {});
    });

    ever(Prefs.didSpecificAmountChanged, (i) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat('#,##0').format(Prefs.amount.get());
    final specificAmount =
        NumberFormat('#,##0').format(Prefs.specificAmount.get());

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(children: [
        themeChangeTile(context),
        settingsTile(
          context,
          title: '순간거래대금 조회조건',
          subtitle: '현재 $amount USDT 이상 화면 표시',
          page: const EditAmountView(),
        ),
        settingsTile(
          context,
          title: '특정거래대금 설정',
          subtitle: '현재 $specificAmount USDT 이상 밑줄 및 알림 사용',
          page: const SpecificAmountSettingView(),
        ),
        settingsTile(
          context,
          title: '바이낸스 테마',
          subtitle: null,
          page: const EditColorView(),
        ),
      ]),
    );
  }

  ListTile themeChangeTile(BuildContext context) => ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('다크 테마'),
            CustomSwitch(
                value: context.isDarkMode,
                onChanged: (value) {
                  ThemeUtil.toggleTheme(context);
                }),
          ],
        ),
      );

  ListTile settingsTile(BuildContext context,
          {required String title,
          required String? subtitle,
          required Widget page}) =>
      ListTile(
        title: Text(title),
        subtitle: (subtitle != null)
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      );
}
