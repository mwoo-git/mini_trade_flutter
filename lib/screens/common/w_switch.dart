import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      // 안드로이드 스위치
      return Switch(
        value: value,
        onChanged: onChanged,
      );
    } else {
      // iOS 스위치 (쿠퍼티노 스위치)
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      );
    }
  }
}
