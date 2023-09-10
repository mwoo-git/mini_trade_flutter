import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/w_switch.dart';
import 'v_edit_amount.dart';
import 'v_edit_color.dart';

import '../../global/theme/theme_util.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(children: [
        themeChangeTile(context),
        settingsTile(
          context,
          title: '순간거래대금 조회조건',
          page: const EditAmountView(),
        ),
        settingsTile(
          context,
          title: '밑줄 강조',
          page: const EditColorView(),
        ),
        settingsTile(
          context,
          title: '소리 / 진동 알림',
          page: const EditColorView(),
        ),
        settingsTile(
          context,
          title: '바이낸스 테마',
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
          {required String title, required Widget page}) =>
      ListTile(
        title: Text(title),
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
