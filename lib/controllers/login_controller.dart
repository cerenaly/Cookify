import 'package:new_futter_app/views/forgot_password_screen.dart';
import 'package:new_futter_app/views/full_app.dart';
import 'package:new_futter_app/views/register_screen.dart';
import 'package:new_futter_app/helpers/utils/my_string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_futter_app/services/auth_service.dart';

class LoginController extends GetxController {
  late TextEditingController emailTE, passwordTE;
  GlobalKey<FormState> formKey = GlobalKey();

  final AuthService _authService = AuthService();
  bool isLoading = false;

  LoginController() {
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
    } else if (!MyStringUtils.validateStringRange(
      text,
    )) {
      return "Password length must between 8 and 20";
    }
    return null;
  }

  void goToForgotPasswordScreen() {
    //Get.off(ForgotPasswordScreen());
    Get.to(() => const ForgotPasswordScreen());
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        update();

        var user = await _authService.signInWithEmailAndPassword(
          emailTE.text,
          passwordTE.text,
        );

        if (user != null) {
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Başarıyla giriş yapıldı!"),
                backgroundColor: Colors.green,
              ),
            );
          }

          // DOĞRU GEÇİŞ YÖNTEMİ:
          // Get.to yerine Get.offAll kullanarak hem login ekranını arkada kapatıyoruz
          // hem de alt bileşenlerin (HomeScreen, Showcase, MealPlan vb.) bağımlılık ağacını tetikliyoruz.
          Get.offAll(() => const FullApp());
        } else {
          // Giriş Başarısızsa (Kullanıcı null döndüyse)
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text("Giriş Başarısız: Bilgilerinizi kontrol edin."),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        print("Login Error: $e");
        // Herhangi bir Firebase hatası yakalanırsa ekrana bas
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

  void goToRegisterScreen() {
    //Get.off(RegisterScreen());
    Get.to(() => const RegisterScreen());
  }
}
