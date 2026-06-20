/*
* File : Main File
* We are using our own package (FlutX) : https://pub.dev/packages/flutx
* Version : 13
* */

import 'package:new_futter_app/helpers/localizations/app_localization_delegate.dart';
import 'package:new_futter_app/helpers/localizations/language.dart';
import 'package:new_futter_app/helpers/theme/app_notifier.dart';
import 'package:new_futter_app/helpers/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// LoginScreen dosyanın yolunu buraya ekliyoruz (Senin proje yapına göre ayarlandı)
import 'package:new_futter_app/views/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Android zaten google-services.json dosyasından her şeyi otomatik okuyacak.
    await Firebase.initializeApp();
    print("FİREBASE ARKA PLAN ENTEGRASYONU BAŞARILI!");
  } catch (e) {
    print("Firebase başlatılırken hata veya çakışma oluştu: $e");
  }

  AppTheme.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ChangeNotifierProvider<AppNotifier>(
      create: (context) => AppNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          // UYGULAMANIN İLK AÇILIŞ EKRANI LOGİNSCREEN OLARAK DEĞİŞTİRİLDİ
          home: const LoginScreen(),
          builder: (context, child) {
            return Directionality(textDirection: AppTheme.textDirection, child: child ?? Container());
          },
          routingCallback: (routing) {
            // AdHelper.routingCallback(routing);
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Language.getLocales(),
        );
      },
    );
  }
}