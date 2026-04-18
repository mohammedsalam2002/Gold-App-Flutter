// lib/features/auth/models/user_model.dart
// نموذج بيانات المستخدم
 
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
 
  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.isEmailVerified = false,
  });
 
  // تحويل من Firebase User
  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified ?? false,
    );
  }
 
  // اسم العرض (يستخدم الاسم إن وُجد، وإلا البريد)
  String get name => displayName ?? email?.split('@').first ?? 'مستخدم';
 
  @override
  String toString() => 'UserModel(uid: $uid, email: $email)';
}
 