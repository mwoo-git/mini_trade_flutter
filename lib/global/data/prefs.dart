import '../theme/custom_theme.dart';
import 'app_preferences.dart';

enum PrefsType {
  binanceTheme,
  amount,
  underline,
  sound,
}

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
  static final amount = RxPreferenceItem<int, RxInt>('amount', 10000);
  static final isBinanceTheme = PreferenceItem<bool>('isGreenOn', false);
  static final didAmountChanged = RxBool(false);
  static final didBinanceThemeChanged = RxBool(false);

  static changePrefs(PrefsType type, dynamic value) {
    switch (type) {
      case PrefsType.binanceTheme:
        isBinanceTheme.set(value);
        didBinanceThemeChanged.toggle();

      case PrefsType.amount:
        amount.set(value);
        didAmountChanged.toggle();

      case PrefsType.underline:
      // TODO: Handle this case.
      case PrefsType.sound:
      // TODO: Handle this case.
    }
  }
}
