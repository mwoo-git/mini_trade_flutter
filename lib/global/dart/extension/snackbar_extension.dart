import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';

extension SnackbarContextExtension on BuildContext {
  ///Scaffold안에 Snackbar를 보여줍니다.
  void showSnackbar(String message, {Widget? extraButton}) {
    _showSnackBarWithContext(
      this,
      _SnackbarFactory.createSnackBar(this, message, extraButton: extraButton),
    );
  }

  ///Scaffold안에 빨간 Snackbar를 보여줍니다.
  void showErrorSnackbar(
    String message, {
    Color bgColor = Colors.red,
    double bottomMargin = 0,
  }) {
    _showSnackBarWithContext(
      this,
      _SnackbarFactory.createErrorSnackBar(
        this,
        message,
        bgColor: bgColor,
        bottomMargin: bottomMargin,
      ),
    );
  }
}

void _showSnackBarWithContext(BuildContext context, SnackBar snackbar) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class _SnackbarFactory {
  static SnackBar createSnackBar(BuildContext context, String message,
      {Color? bgColor, Widget? extraButton}) {
    Color snackbarBgColor = bgColor ?? context.appColors.textColor;
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: Tap(
          onTap: () {
            try {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } catch (e) {
              //do nothing
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: snackbarBgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(message,
                      style: TextStyle(
                        color: context.appColors.background,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                      )),
                ),
                if (extraButton != null) extraButton,
              ],
            ),
          ),
        ));
  }

  static SnackBar createErrorSnackBar(BuildContext context, String? message,
      {Color bgColor = Colors.black, double bottomMargin = 0}) {
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: Tap(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: bottomMargin),
            child: Text("$message",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                )),
          ),
        ));
  }
}

class Tap extends StatelessWidget {
  final void Function() onTap;
  final void Function()? onLongPress;
  final Widget child;

  const Tap({Key? key, required this.onTap, required this.child, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
