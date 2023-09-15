import '../theme/custom_theme.dart';
import 'app_preferences.dart';

enum PrefsType {
  binanceTheme,
  amount,
  underline,
  sound,
  specificAmount,
  vibrate,
}

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
  static final amount = RxPreferenceItem<int, RxInt>('amount', 10000);
  static final isBinanceTheme = PreferenceItem<bool>('isGreenOn', false);
  static final underline = PreferenceItem<bool>('underline', true);
  static final specificAmount =
      RxPreferenceItem<int, RxInt>('specificAmount', 100000);
  static final sound = PreferenceItem<bool>('sound', false);
  static final vibrate = PreferenceItem<bool>('vibrate', false);

  static final didAmountChanged = RxBool(false);
  static final didBinanceThemeChanged = RxBool(false);
  static final didUnderlineChanged = RxBool(false);
  static final didSoundChanged = RxBool(false);
  static final didSpecificAmountChanged = RxBool(false);
  static final didVibrateChanged = RxBool(false);

  static changePrefs(PrefsType type, dynamic value) {
    switch (type) {
      case PrefsType.binanceTheme:
        isBinanceTheme.set(value);
        didBinanceThemeChanged.toggle();

      case PrefsType.amount:
        amount.set(value);
        didAmountChanged.toggle();

      case PrefsType.underline:
        underline.set(value);
        didUnderlineChanged.toggle();

      case PrefsType.sound:
        sound.set(value);
        didSoundChanged.toggle();

      case PrefsType.specificAmount:
        specificAmount.set(value);
        didSpecificAmountChanged.toggle();
      case PrefsType.vibrate:
        vibrate.set(value);
        didVibrateChanged.toggle();
    }
  }
}
