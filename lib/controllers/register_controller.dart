import 'package:new_futter_app/views/forgot_password_screen.dart';
import 'package:new_futter_app/views/full_app.dart';
import 'package:new_futter_app/views/login_screen.dart';
import 'package:new_futter_app/helpers/utils/my_string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Kendi AuthService dosyanın yolunu buraya eklemeyi unutma
import 'package:new_futter_app/services/auth_service.dart'; // Örn: auth_service.dart neredeyse orayı import et
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  late TextEditingController nameTE, emailTE, passwordTE;
  GlobalKey<FormState> formKey = GlobalKey();

  // AuthService nesnemizi oluşturuyoruz
  final AuthService _authService = AuthService();

  // Ekran yükleniyor durumunu kontrol etmek için (İstersen butonda loading gösterebilirsin)
  bool isLoading = false;

  RegisterController() {
    nameTE = TextEditingController();
    emailTE = TextEditingController();
    passwordTE = TextEditingController();
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (!MyStringUtils.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!MyStringUtils.validateStringRange(text, 8, 20)) {
      return "Password length must between 8 and 20";
    }
    return null;
  }

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter name";
    } else if (!MyStringUtils.validateStringRange(text, 4, 20)) {
      return "Name length must between 4 and 20";
    }
    return null;
  }

  void goToForgotPasswordScreen() {
    Get.off(ForgotPasswordScreen());
  }

  // Fonksiyonu async hale getirdik ve Firebase bağlantısını kurduk
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        update(); // UI'ı haberdar et

        // Firebase Auth servisimizle kayıt açıyoruz
        var user = await _authService.registerWithEmailAndPassword(
          emailTE.text,
          passwordTE.text,
        );

        if (user != null) {
          // Kayıt başarılıysa ScaffoldMessenger ile güvenli bir yeşil bar gösteriyoruz
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', nameTE.text);
          await prefs.setString('user_email', emailTE.text);

          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Hesabınız başarıyla oluşturuldu!"),
                backgroundColor: Colors.green,
              ),
            );
          }
          // Ana sayfaya yönlendir
          Get.off(FullApp());
        } else {
          // Eğer servis null döndüyse genel bir hata mesajı
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Kayıt başarısız. Lütfen bilgilerinizi kontrol edin."),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        print("Register Error: $e");
        // Firebase'den dönen spesifik bir hata varsa (Örn: email-already-in-use) ekrana basar
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text("Hata: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  void goToLogInScreen() {
    Get.off(LoginScreen());
  }
}