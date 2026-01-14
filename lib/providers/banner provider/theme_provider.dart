import 'package:brodbay/models/banner%20model/theme_model.dart';
import 'package:brodbay/widgets/Theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<AppThemeModel> {
  ThemeNotifier() : super(defaultTheme);

  void applyCampaign(String campaign) {
    switch (campaign) {
      case 'pink_sale':
        state = pinkSaleTheme;
        break;
      case 'green_sale':
        state = greenSaleTheme;
        break;
      default:
        state = defaultTheme;
    }
  }

  void reset() {
    state = defaultTheme;
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeModel>((ref) {
  return ThemeNotifier();
});
