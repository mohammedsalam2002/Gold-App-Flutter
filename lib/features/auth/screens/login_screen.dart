// lib/features/auth/screens/login_screen.dart
// شاشة تسجيل الدخول - بريد/كلمة مرور + Google
 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../../home/screens/home_screen.dart';
 
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
 
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
 
  bool _isSignUp = false;    // للتبديل بين الدخول والتسجيل
  bool _obscurePassword = true; // إخفاء/إظهار كلمة المرور
 
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 
  // تسجيل الدخول بالبريد
  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;
 
    final notifier = ref.read(authActionsProvider.notifier);
    bool success;
 
    if (_isSignUp) {
      success = await notifier.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      success = await notifier.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
 
    if (success && mounted) {
      _navigateToHome();
    }
  }
 
  // تسجيل الدخول بـ Google
  Future<void> _handleGoogleSignIn() async {
    final success = await ref.read(authActionsProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      _navigateToHome();
    }
  }
 
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authActionsProvider);
    final isLoading = authState is AsyncLoading;
 
    // عرض رسالة الخطأ
    ref.listen(authActionsProvider, (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(fontFamily: 'Cairo'),
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authActionsProvider.notifier).clearError();
      }
    });
 
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.primaryColor, Color(0xFF16213E)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ======= اللوجو =======
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppTheme.goldColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.monetization_on_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'أسعار الذهب العراق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.goldColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp ? 'إنشاء حساب جديد' : 'مرحباً بك!',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),
 
                    // ======= بطاقة النموذج =======
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // حقل البريد الإلكتروني
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                                decoration: const InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'أدخل البريد الإلكتروني';
                                  }
                                  if (!value.contains('@')) {
                                    return 'بريد إلكتروني غير صالح';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
 
                              // حقل كلمة المرور
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'أدخل كلمة المرور';
                                  }
                                  if (value.length < 6) {
                                    return 'كلمة المرور 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
 
                              // زر الدخول / التسجيل
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleEmailAuth,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _isSignUp ? 'إنشاء حساب' : 'تسجيل الدخول',
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
 
                              // تبديل بين الدخول والتسجيل
                              TextButton(
                                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                                child: Text(
                                  _isSignUp
                                      ? 'لديك حساب؟ سجّل الدخول'
                                      : 'ليس لديك حساب؟ أنشئ حساباً',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppTheme.goldColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
 
                    // ======= فاصل =======
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white30)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو',
                            style: TextStyle(color: Colors.white54, fontFamily: 'Cairo'),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white30)),
                      ],
                    ),
                    const SizedBox(height: 20),
 
                    // ======= زر Google =======
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : _handleGoogleSignIn,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                        label: const Text(
                          'الدخول بحساب Google',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
 
                    // تخطي الدخول (للاختبار فقط)
                    TextButton(
                      onPressed: _navigateToHome,
                      child: const Text(
                        'تخطي (للاختبار)',
                        style: TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}