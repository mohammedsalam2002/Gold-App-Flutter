// lib/core/utils/app_utils.dart
// دوال مساعدة مشتركة في التطبيق
 
import 'package:intl/intl.dart';
 
class AppUtils {
  AppUtils._();
 
  // تنسيق الأرقام بالفاصلة للأرقام الكبيرة
  // مثال: 1500 → 1,500
  static String formatNumber(double number, {int decimals = 0}) {
    final formatter = NumberFormat('#,##0${decimals > 0 ? '.' + '0' * decimals : ''}');
    return formatter.format(number);
  }
 
  // تنسيق التاريخ والوقت بالعربية
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(dateTime);
  }
 
  // تنسيق الوقت فقط
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a', 'ar').format(dateTime);
  }
 
  // التحقق من صلاحية الـ Cache
  // يرجع true إذا كان الـ Cache لا يزال صالحاً
  static bool isCacheValid(String? lastUpdateIso, {int validityHours = 1}) {
    if (lastUpdateIso == null) return false;
    try {
      final lastUpdate = DateTime.parse(lastUpdateIso);
      final difference = DateTime.now().difference(lastUpdate);
      return difference.inHours < validityHours;
    } catch (_) {
      return false;
    }
  }
}