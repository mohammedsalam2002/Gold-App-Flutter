// lib/features/home/providers/home_provider.dart
// Providers لإدارة حالة الصفحة الرئيسية باستخدام Riverpod

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gold_price_model.dart';
import '../services/gold_repository.dart';

// ============================
// Provider لـ Repository (Singleton)
// ============================
final goldRepositoryProvider = Provider<GoldRepository>((ref) {
  return GoldRepository();
});

// ============================
// AsyncNotifier لأسعار الذهب
// يدير حالات: Loading / Data / Error
// ============================
final goldPricesProvider =
    AsyncNotifierProvider<GoldPricesNotifier, GoldPriceModel>(() {
  return GoldPricesNotifier();
});

class GoldPricesNotifier extends AsyncNotifier<GoldPriceModel> {
  @override
  Future<GoldPriceModel> build() async {
    // يُستدعى تلقائياً عند أول استخدام
    return _loadPrices();
  }

  Future<GoldPriceModel> _loadPrices({bool forceRefresh = false}) {
    final repository = ref.read(goldRepositoryProvider);
    return repository.getGoldPrices(forceRefresh: forceRefresh);
  }

  // تحديث البيانات يدوياً
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadPrices(forceRefresh: true));
  }
}

// ============================
// AsyncNotifier لسعر الدولار
// ============================
final dollarRateProvider =
    AsyncNotifierProvider<DollarRateNotifier, DollarRateModel>(() {
  return DollarRateNotifier();
});

class DollarRateNotifier extends AsyncNotifier<DollarRateModel> {
  @override
  Future<DollarRateModel> build() async {
    return _loadRate();
  }

  Future<DollarRateModel> _loadRate({bool forceRefresh = false}) {
    final repository = ref.read(goldRepositoryProvider);
    return repository.getDollarRate(forceRefresh: forceRefresh);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadRate(forceRefresh: true));
  }
}