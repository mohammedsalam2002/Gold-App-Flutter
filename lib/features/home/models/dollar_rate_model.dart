// lib/data/models/dollar_rate_model.dart

class DollarRateModel {
  final int      id;
  final double   buyRate;
  final double   sellRate;
  final double   centralRate;
  final DateTime createdAt;
  final bool     isFromCache;

  const DollarRateModel({
    required this.id,
    required this.buyRate,
    required this.sellRate,
    required this.centralRate,
    required this.createdAt,
    this.isFromCache = false,
  });

  // ① من Supabase JSON
  factory DollarRateModel.fromJson(Map<String, dynamic> json) {
    return DollarRateModel(
      id:          json['id']           as int,
      buyRate:     (json['buy_rate']    as num).toDouble(),
      sellRate:    (json['sell_rate']   as num).toDouble(),
      centralRate: (json['central_rate'] as num).toDouble(),
      createdAt:   DateTime.parse(json['created_at'] as String),
    );
  }

  // ② للتخزين المحلي
  Map<String, dynamic> toJson() => {
    'id':           id,
    'buy_rate':     buyRate,
    'sell_rate':    sellRate,
    'central_rate': centralRate,
    'created_at':   createdAt.toIso8601String(),
  };

  // ③ Mock Data
  factory DollarRateModel.mock() {
    return DollarRateModel(
      id:          1,
      buyRate:     1480,
      sellRate:    1490,
      centralRate: 1460,
      createdAt:   DateTime.now(),
    );
  }

  DollarRateModel copyWith({bool? isFromCache}) {
    return DollarRateModel(
      id:          id,
      buyRate:     buyRate,
      sellRate:    sellRate,
      centralRate: centralRate,
      createdAt:   createdAt,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}