import 'package:new_futter_app/views/login_screen.dart';
import 'package:new_futter_app/views/register_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void goToLogInScreen() {
    Get.to(LoginScreen());
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
  }

  void goToRegisterScreen() {
    Get.to(RegisterScreen());
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(
    //     builder: (context) => RegisterScreen(),
    //   ),
    // );
  }
}
