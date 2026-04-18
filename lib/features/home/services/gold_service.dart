// lib/features/home/services/gold_service.dart
// خدمة البيانات - Mock Data الآن، وقابلة للتبديل بـ API لاحقاً
//
// ============================================================
// كيفية الانتقال من Mock Data إلى API حقيقي:
// 1. أضف dependency: http أو dio في pubspec.yaml
// 2. في دالة fetchGoldPrices():
//    - احذف قسم "// ===== MOCK DATA ====="
//    - استبدله بـ HTTP call حقيقي
//    - مثال:
//      final response = await http.get(Uri.parse(AppConstants.goldPricesEndpoint));
//      final json = jsonDecode(response.body);
//      return GoldPriceModel.fromJson(json);
// ============================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_utils.dart';
import '../models/gold_price_model.dart';

class GoldService {
  // ============================
  // جلب أسعار الذهب
  // ============================
  Future<GoldPriceModel> fetchGoldPrices() async {
    // الخطوة 1: تحقق من الـ Cache أولاً
    final cached = await _getCachedGoldPrices();
    if (cached != null) {
      return cached;
    }

    // الخطوة 2: إذا لا يوجد Cache صالح → جلب من Mock Data (أو API لاحقاً)
    final data = await _fetchGoldPricesFromSource();

    // الخطوة 3: حفظ في الـ Cache
    await _cacheGoldPrices(data);

    return data;
  }

  // ============================
  // جلب سعر الدولار
  // ============================
  Future<DollarRateModel> fetchDollarRate() async {
    final cached = await _getCachedDollarRate();
    if (cached != null) {
      return cached;
    }

    final data = await _fetchDollarRateFromSource();
    await _cacheDollarRate(data);

    return data;
  }

  // ============================
  // إجبار تحديث البيانات (تجاهل الـ Cache)
  // ============================
  Future<GoldPriceModel> refreshGoldPrices() async {
    await _clearGoldCache();
    return fetchGoldPrices();
  }

  Future<DollarRateModel> refreshDollarRate() async {
    await _clearDollarCache();
    return fetchDollarRate();
  }

  // ============================
  // ===== MOCK DATA =====
  // استبدل هذا القسم بـ API حقيقي لاحقاً
  // ============================
  Future<GoldPriceModel> _fetchGoldPricesFromSource() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));

    // بيانات تجريبية واقعية (أسعار تقريبية بالدينار العراقي - غرام)
    return GoldPriceModel(
      karat24: 285000, // 285,000 دينار للغرام عيار 24
      karat21: 249000, // 249,000 دينار للغرام عيار 21
      karat18: 213000, // 213,000 دينار للغرام عيار 18
      ouncePrice: 2050, // سعر الأونصة الدولية بالدولار
      lastUpdated: DateTime.now(),
    );
  }

  Future<DollarRateModel> _fetchDollarRateFromSource() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return DollarRateModel(
      buyRate: 1480,     // سعر شراء الدولار بالدينار
      sellRate: 1490,    // سعر بيع الدولار
      centralRate: 1460, // سعر البنك المركزي الرسمي
      lastUpdated: DateTime.now(),
    );
  }
  // ===== نهاية MOCK DATA =====

  // ============================
  // Cache - SharedPreferences
  // ============================
  Future<GoldPriceModel?> _getCachedGoldPrices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(AppConstants.prefKeyCachedGoldPrices);
      final lastUpdate = prefs.getString(AppConstants.prefKeyLastUpdate);

      if (jsonString == null) return null;
      if (!AppUtils.isCacheValid(lastUpdate,
          validityHours: AppConstants.cacheValidityHours)) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return GoldPriceModel.fromJson(json).copyWith(isFromCache: true);
    } catch (_) {
      return null;
    }
  }

  Future<DollarRateModel?> _getCachedDollarRate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(AppConstants.prefKeyCachedDollarRate);
      final lastUpdate = prefs.getString(AppConstants.prefKeyLastUpdate);

      if (jsonString == null) return null;
      if (!AppUtils.isCacheValid(lastUpdate,
          validityHours: AppConstants.cacheValidityHours)) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DollarRateModel.fromJson(json).copyWith(isFromCache: true);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheGoldPrices(GoldPriceModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefKeyCachedGoldPrices,
      jsonEncode(data.toJson()),
    );
    await prefs.setString(
      AppConstants.prefKeyLastUpdate,
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> _cacheDollarRate(DollarRateModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefKeyCachedDollarRate,
      jsonEncode(data.toJson()),
    );
  }

  Future<void> _clearGoldCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyCachedGoldPrices);
    await prefs.remove(AppConstants.prefKeyLastUpdate);
  }

  Future<void> _clearDollarCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyCachedDollarRate);
  }
}

// Extension لـ DollarRateModel لإضافة copyWith
extension DollarRateModelX on DollarRateModel {
  DollarRateModel copyWith({
    double? buyRate,
    double? sellRate,
    double? centralRate,
    DateTime? lastUpdated,
    bool? isFromCache,
  }) {
    return DollarRateModel(
      buyRate: buyRate ?? this.buyRate,
      sellRate: sellRate ?? this.sellRate,
      centralRate: centralRate ?? this.centralRate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}