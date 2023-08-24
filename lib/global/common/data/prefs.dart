import 'app_preferences.dart';

class Prefs {
  // static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
  static final amount = RxPreferenceItem<int, RxInt>('amount', 50000);
}
