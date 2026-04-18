// lib/data/models/gold_price_model.dart

class GoldPriceModel {
  final int     id;
  final double  karat18;
  final double  karat21;
  final double  karat24;
  final double  ouncePrice;
  final DateTime createdAt;
  final bool    isFromCache;

  const GoldPriceModel({
    required this.id,
    required this.karat18,
    required this.karat21,
    required this.karat24,
    required this.ouncePrice,
    required this.createdAt,
    this.isFromCache = false,
  });

  // ① من Supabase JSON
  factory GoldPriceModel.fromJson(Map<String, dynamic> json) {
    return GoldPriceModel(
      id:         json['id']          as int,
      karat18:    (json['karat_18']   as num).toDouble(),
      karat21:    (json['karat_21']   as num).toDouble(),
      karat24:    (json['karat_24']   as num).toDouble(),
      ouncePrice: (json['ounce_price'] as num).toDouble(),
      createdAt:  DateTime.parse(json['created_at'] as String),
    );
  }

  // ② للتخزين المحلي
  Map<String, dynamic> toJson() => {
    'id':          id,
    'karat_18':    karat18,
    'karat_21':    karat21,
    'karat_24':    karat24,
    'ounce_price': ouncePrice,
    'created_at':  createdAt.toIso8601String(),
  };

  // ③ Mock Data للاختبار
  factory GoldPriceModel.mock() {
    return GoldPriceModel(
      id:         1,
      karat18:    213000,
      karat21:    249000,
      karat24:    285000,
      ouncePrice: 2050,
      createdAt:  DateTime.now(),
    );
  }

  GoldPriceModel copyWith({bool? isFromCache}) {
    return GoldPriceModel(
      id:          id,
      karat18:     karat18,
      karat21:     karat21,
      karat24:     karat24,
      ouncePrice:  ouncePrice,
      createdAt:   createdAt,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}