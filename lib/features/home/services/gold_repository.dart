// lib/features/home/services/gold_repository.dart
// Repository Pattern - يفصل منطق الأعمال عن الـ Service والـ UI
// هذا الكلاس هو المسؤول الوحيد عن البيانات من وجهة نظر الـ UI

import '../models/gold_price_model.dart';
import 'gold_service.dart';

// ============================
// Abstract Interface
// يسهّل عمل Unit Tests واستبدال الـ Implementation لاحقاً
// ============================
abstract class GoldRepositoryInterface {
  Future<GoldPriceModel> getGoldPrices({bool forceRefresh = false});
  Future<DollarRateModel> getDollarRate({bool forceRefresh = false});
}

// ============================
// التطبيق الفعلي
// ============================
class GoldRepository implements GoldRepositoryInterface {
  final GoldService _service;

  GoldRepository({GoldService? service}) : _service = service ?? GoldService();

  @override
  Future<GoldPriceModel> getGoldPrices({bool forceRefresh = false}) async {
    if (forceRefresh) {
      return _service.refreshGoldPrices();
    }
    return _service.fetchGoldPrices();
  }

  @override
  Future<DollarRateModel> getDollarRate({bool forceRefresh = false}) async {
    if (forceRefresh) {
      return _service.refreshDollarRate();
    }
    return _service.fetchDollarRate();
  }
}