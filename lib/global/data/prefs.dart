import '../theme/custom_theme.dart';
import 'app_preferences.dart';

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
  static final amount = RxPreferenceItem<int, RxInt>('amount', 10000);
  static final isBinanceTheme = PreferenceItem<bool>('isGreenOn', false);
  static final didAmountChanged = RxBool(false);
  static final didBinanceThemeChanged = RxBool(false);
}