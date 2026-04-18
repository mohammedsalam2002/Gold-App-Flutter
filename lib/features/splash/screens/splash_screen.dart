// lib/features/splash/screens/splash_screen.dart
// شاشة البداية مع Animation
 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../home/screens/home_screen.dart';
 
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
 
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Controllers لتأثيرات الـ Animation
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
 
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }
 
  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
 
    // تأثير Fade (ظهور تدريجي)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
 
    // تأثير Scale (تكبير تدريجي)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
 
    _controller.forward(); // بدء الـ Animation
  }
 
  void _navigateAfterDelay() async {
    // انتظر مدة الـ Splash
    await Future.delayed(
      const Duration(seconds: AppConstants.splashDurationSeconds),
    );
 
    if (!mounted) return;
 
    // تحقق من حالة تسجيل الدخول
    final authState = ref.read(authProvider);
 
    authState.when(
      data: (user) {
        // إذا المستخدم مسجّل → الصفحة الرئيسية
        // إذا غير مسجّل → صفحة الدخول
        final destination = user != null
            ? const HomeScreen()
            : const LoginScreen();
 
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => destination,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      loading: () {
        // إذا لا يزال يتحقق → انتقل لصفحة الدخول
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      error: (_, __) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة الذهب
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.goldColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldColor.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
 
              // اسم التطبيق
              const Text(
                'أسعار الذهب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldColor,
                  letterSpacing: 1,
                ),
              ),
              const Text(
                'العراق',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),
 
              // مؤشر التحميل
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AppTheme.goldColor,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'جاري التحميل...',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}