import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. E-posta ve Şifre ile Giriş Yap (Sign In)
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      print("Beklenmedik giriş hatası: $e");
      return null;
    }
  }

  // 2. Yeni Hesap Oluştur (Sign Up)
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  // 3. Çıkış Yap (Sign Out)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firebase Hatalarını Yakalama ve Türkçeleştirme
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        print('HATA: Bu e-posta adresine ait kullanıcı bulunamadı.');
        break;
      case 'wrong-password':
        print('HATA: Hatalı şifre girdiniz.');
        break;
      case 'email-already-in-use':
        print('HATA: Bu e-posta adresi zaten kullanımda.');
        break;
      case 'invalid-email':
        print('HATA: Geçersiz bir e-posta adresi girdiniz.');
        break;
      case 'weak-password':
        print('HATA: Girdiğiniz şifre çok zayıf.');
        break;
      default:
        print('Firebase Auth Hatası (${e.code}): ${e.message}');
    }
  }
}