import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/screens/settings/v_edit_amount.dart';
import 'package:mini_trade_flutter/screens/settings/v_edit_color.dart';
import 'package:mini_trade_flutter/screens/settings/v_edit_theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(children: [
        settingsTile(
          context,
          title: '순간거래대금 조회조건',
          page: const EditAmountView(),
        ),
        settingsTile(
          context,
          title: '매수/매도 색상',
          page: const EditColorView(),
        ),
        settingsTile(
          context,
          title: '앱 라이트/다크 테마',
          page: const EditThemeView(),
        )
      ]),
    );
  }

  ListTile settingsTile(BuildContext context,
      {required String title, required Widget page}) {
    return ListTile(
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
}
