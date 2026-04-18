// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // ============================
  // معلومات التطبيق
  // ============================
  static const String appName    = 'أسعار الذهب العراق';
  static const String appVersion = '1.0.0';

  // ============================
  // Supabase - ضع مفاتيحك هنا
  // ============================
  static const String supabaseUrl = 'https://iqnocnlgrqjadncrighm.supabase.co';
  static const String supabaseKey = 'sb_publishable_MgBOsSynvEW-8u_Vm5duAw_eDvkIpII';

  // ============================
  // أسماء الجداول
  // ============================
  static const String tableGoldPrices   = 'gold_prices';
  static const String tableDollarPrices = 'dollar_prices';

  // ============================
  // API - ستضيفها لاحقاً
  // ============================
  static const String goldApiUrl   = 'YOUR_GOLD_API_URL';
  static const String dollarApiUrl = 'YOUR_DOLLAR_API_URL';

  // ============================
  // Cache
  // ============================
  static const String prefKeyThemeMode        = 'theme_mode';
  static const String prefKeyCachedGold       = 'cached_gold';
  static const String prefKeyCachedDollar     = 'cached_dollar';
  static const String prefKeyLastUpdate       = 'last_update';
  static const int    cacheValidityHours      = 1;

  // ============================
  // AdMob
  // ============================
  static const String admobBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111'; // Test
  static const String admobBannerIOS =
      'ca-app-pub-3940256099942544/2934735716'; // Test

  // ============================
  // Splash
  // ============================
  static const int splashDuration = 3;
}