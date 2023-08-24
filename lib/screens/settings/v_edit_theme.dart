import 'package:flutter/material.dart';

class EditThemeView extends StatelessWidget {
  const EditThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 라이트/다크 테마'),
      ),
    );
  }
}
