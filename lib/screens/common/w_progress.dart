import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      width: 30.0, // 원하는 너비
      height: 30.0, // 원하는 높이
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    ));
  }
}
