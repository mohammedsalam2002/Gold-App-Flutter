// lib/features/auth/providers/auth_provider.dart
// إدارة حالة المصادقة باستخدام Riverpod
 
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../models/user_model.dart';
import '../services/auth_service.dart';
 
// ============================
// Provider لـ AuthService (Singleton)
// ============================
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
 
// ============================
// StreamProvider لمراقبة حالة تسجيل الدخول
// يُحدَّث تلقائياً عند تسجيل الدخول أو الخروج
// ============================
final authProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
 
// ============================
// StateNotifier لإجراءات المصادقة
// (تسجيل دخول، خروج، إنشاء حساب)
// ============================
final authActionsProvider =
    StateNotifierProvider<AuthActionsNotifier, AsyncValue<void>>((ref) {
  return AuthActionsNotifier(ref.watch(authServiceProvider));
});
 
class AuthActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
 
  AuthActionsNotifier(this._authService) : super(const AsyncValue.data(null));
 
  // تسجيل الدخول بالبريد
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithEmail(email: email, password: password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
 
  // إنشاء حساب جديد
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
 
  // تسجيل الدخول بـ Google
  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithGoogle();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
 
  // تسجيل الخروج
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
 
  // إزالة رسالة الخطأ
  void clearError() {
    if (state is AsyncError) {
      state = const AsyncValue.data(null);
    }
  }
}
 