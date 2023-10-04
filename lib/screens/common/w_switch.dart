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
      return Theme(
        data: ThemeData(),
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Colors.green, // 활성 상태의 트랙 색상
          activeColor: Colors.white, // 활성 상태의 스위치 색상
        ),
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
