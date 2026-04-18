// lib/features/home/screens/home_screen.dart
// الصفحة الرئيسية - عرض أسعار الذهب والدولار

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../models/gold_price_model.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goldState = ref.watch(goldPricesProvider);
    final dollarState = ref.watch(dollarRateProvider);
    final isDark = ref.watch(themeModeProvider.notifier).isDark;
    final authState = ref.watch(authProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أسعار الذهب والدولار'),
          actions: [
            // زر تبديل الثيم
            IconButton(
              icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
              tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
            ),
            // زر تسجيل الخروج
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => _confirmSignOut(context, ref),
              tooltip: 'تسجيل الخروج',
            ),
          ],
        ),
        body: Column(
          children: [
            // Banner Ad في الأعلى
            const AdBannerWidget(),

            Expanded(
              child: RefreshIndicator(
                color: AppTheme.goldColor,
                // السحب للأسفل لتحديث البيانات
                onRefresh: () async {
                  await Future.wait([
                    ref.read(goldPricesProvider.notifier).refresh(),
                    ref.read(dollarRateProvider.notifier).refresh(),
                  ]);
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ===== ترحيب =====
                    _buildWelcomeHeader(context, authState),
                    const SizedBox(height: 20),

                    // ===== قسم الدولار =====
                    _buildSectionTitle(context, 'سعر الدولار', Icons.attach_money_rounded),
                    const SizedBox(height: 8),
                    dollarState.when(
                      data: (data) => _buildDollarCard(context, data),
                      loading: () => _buildLoadingCard(),
                      error: (e, _) => _buildErrorCard(
                        context,
                        e.toString(),
                        () => ref.read(dollarRateProvider.notifier).refresh(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== قسم الذهب =====
                    _buildSectionTitle(context, 'أسعار الذهب', Icons.monetization_on_rounded),
                    const SizedBox(height: 8),
                    goldState.when(
                      data: (data) => _buildGoldCards(context, data),
                      loading: () => _buildLoadingCard(),
                      error: (e, _) => _buildErrorCard(
                        context,
                        e.toString(),
                        () => ref.read(goldPricesProvider.notifier).refresh(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== وقت آخر تحديث =====
                    //goldState.whenData((data) => _buildLastUpdated(context, data)),

                    // مسافة إضافية للإعلان السفلي
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Banner Ad في الأسفل
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  // ============================
  // Widgets مساعدة
  // ============================

  Widget _buildWelcomeHeader(BuildContext context, AsyncValue authState) {
    return authState.when(
      data: (user) {
        final name = user?.name ?? 'زائر';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.accentColor],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.waving_hand_rounded, color: AppTheme.goldColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، $name',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'اسحب للأسفل لتحديث الأسعار',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.goldColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // بطاقة سعر الدولار
  Widget _buildDollarCard(BuildContext context, DollarRateModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cache indicator
            if (data.isFromCache)
              const _CacheBadge(),

            Row(
              children: [
                Expanded(
                  child: _PriceItem(
                    label: 'شراء',
                    value: AppUtils.formatNumber(data.buyRate),
                    suffix: 'د.ع',
                    color: AppTheme.successColor,
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
                Container(width: 1, height: 60, color: Colors.grey.shade300),
                Expanded(
                  child: _PriceItem(
                    label: 'بيع',
                    value: AppUtils.formatNumber(data.sellRate),
                    suffix: 'د.ع',
                    color: AppTheme.errorColor,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
                Container(width: 1, height: 60, color: Colors.grey.shade300),
                Expanded(
                  child: _PriceItem(
                    label: 'المركزي',
                    value: AppUtils.formatNumber(data.centralRate),
                    suffix: 'د.ع',
                    color: AppTheme.dollarGreen,
                    icon: Icons.account_balance_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // بطاقات الذهب (ثلاثة عيارات)
  Widget _buildGoldCards(BuildContext context, GoldPriceModel data) {
    final karats = [
      {'label': 'عيار 24', 'value': data.karat24, 'purity': '99.9%'},
      {'label': 'عيار 21', 'value': data.karat21, 'purity': '87.5%'},
      {'label': 'عيار 18', 'value': data.karat18, 'purity': '75.0%'},
    ];

    return Column(
      children: [
        if (data.isFromCache) const _CacheBadge(),
        ...karats.map((karat) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GoldKaratCard(
                label: karat['label'] as String,
                pricePerGram: karat['value'] as double,
                purity: karat['purity'] as String,
              ),
            )),
        // بطاقة سعر الأونصة الدولية
        Card(
          color: AppTheme.primaryColor,
          child: ListTile(
            leading: const Icon(Icons.public_rounded, color: AppTheme.goldColor),
            title: const Text(
              'سعر الأونصة الدولية',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
            trailing: Text(
              '\$${AppUtils.formatNumber(data.ouncePrice)}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppTheme.goldColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated(BuildContext context, GoldPriceModel data) {
    return Center(
      child: Text(
        'آخر تحديث: ${AppUtils.formatDateTime(data.lastUpdated)}',
        style: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.goldColor),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error, VoidCallback onRetry) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppTheme.errorColor, size: 40),
            const SizedBox(height: 8),
            Text(
              error.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج', style: TextStyle(fontFamily: 'Cairo')),
          content: const Text('هل تريد تسجيل الخروج؟', style: TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('خروج', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(authActionsProvider.notifier).signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }
}

// ============================
// Widgets صغيرة مساعدة
// ============================

class _PriceItem extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color color;
  final IconData icon;

  const _PriceItem({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(suffix, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _GoldKaratCard extends StatelessWidget {
  final String label;
  final double pricePerGram;
  final String purity;

  const _GoldKaratCard({
    required this.label,
    required this.pricePerGram,
    required this.purity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.goldColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label.split(' ')[1], // الرقم فقط (18، 21، 24)
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: AppTheme.goldColor,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'نقاء $purity',
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppUtils.formatNumber(pricePerGram),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldColor,
              ),
            ),
            const Text(
              'دينار/غرام',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _CacheBadge extends StatelessWidget {
  const _CacheBadge();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cached_rounded, size: 14, color: Colors.orange),
                SizedBox(width: 4),
                Text(
                  'بيانات محفوظة - اسحب للتحديث',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}