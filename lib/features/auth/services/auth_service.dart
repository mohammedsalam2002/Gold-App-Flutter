// lib/features/auth/services/auth_service.dart
// خدمة المصادقة - تتعامل مع Firebase Auth مباشرة
 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
 
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
 
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
 
  // ============================
  // Stream لمراقبة حالة تسجيل الدخول
  // ============================
  Stream<UserModel?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return UserModel.fromFirebaseUser(user);
      });
 
  // ============================
  // تسجيل الدخول بالبريد وكلمة المرور
  // ============================
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }
 
  // ============================
  // إنشاء حساب جديد بالبريد وكلمة المرور
  // ============================
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
 
      // تحديث اسم المستخدم إن وُجد
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
      }
 
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }
 
  // ============================
  // تسجيل الدخول بـ Google
  // ============================
  Future<UserModel> signInWithGoogle() async {
    try {
      // فتح نافذة اختيار حساب Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('تم إلغاء تسجيل الدخول بـ Google');
      }
 
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
 
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }
 
  // ============================
  // تسجيل الخروج
  // ============================
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
 
  // ============================
  // المستخدم الحالي
  // ============================
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }
 
  // ============================
  // تحويل أخطاء Firebase لرسائل عربية
  // ============================
  Exception _handleFirebaseError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'البريد الإلكتروني غير مسجّل';
        break;
      case 'wrong-password':
        message = 'كلمة المرور غير صحيحة';
        break;
      case 'email-already-in-use':
        message = 'البريد الإلكتروني مستخدم مسبقاً';
        break;
      case 'invalid-email':
        message = 'البريد الإلكتروني غير صالح';
        break;
      case 'weak-password':
        message = 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
        break;
      case 'too-many-requests':
        message = 'محاولات كثيرة، حاول لاحقاً';
        break;
      case 'network-request-failed':
        message = 'تحقق من اتصال الإنترنت';
        break;
      default:
        message = 'حدث خطأ: ${e.message}';
    }
    return Exception(message);
  }
}
 