import 'dart:io';
import 'package:new_futter_app/models/user.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  bool showLoading = true, uiLoading = true;
  late User user;
  String displayName = "Den";
  String displayEmail = "den@gmail.com";

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final String _storageKey = "profile_image_path";

  @override
  void onInit() {
    fetchData();
    super.onInit();
    loadUserData();
  }

  void fetchData() async {
    user = await User.getOne();
    await Future.delayed(Duration(seconds: 1));
    await _loadSavedImage();
    showLoading = false;
    uiLoading = false;
    update();
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedName = prefs.getString('user_name');
    String? savedEmail = prefs.getString('user_email');

    if (savedName != null && savedName.isNotEmpty) {
      displayName = savedName;
    }
    if (savedEmail != null && savedEmail.isNotEmpty) {
      displayEmail = savedEmail;
    }

    update(); // Arayüzün (ProfileScreen) yenilenmesini tetikle
  }

  // Hem kamerayı hem galeriyi destekleyen esnek fonksiyon
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source, // Burası dışarıdan ImageSource.camera veya ImageSource.gallery alacak
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update();

        // Seçilen yeni resmin yolunu yerel hafızaya (cache) kalıcı olarak yaz
        await _saveImageToCache(pickedFile.path);
      }
    } catch (e) {
      print("Medya seçilirken hata oluştu: $e");
    }
  }

  // 1. Yerel Hafızaya Resmi Kaydetme Fonksiyonu
  Future<void> _saveImageToCache(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, path);
  }

  // 2. Yerel Hafızadan Resmi Geri Yükleme Fonksiyonu
  Future<void> _loadSavedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath = prefs.getString(_storageKey);

    if (savedPath != null && savedPath.isNotEmpty) {
      File file = File(savedPath);
      // Cihazdaki dosya gerçekten yerinde duruyor mu kontrol et
      if (await file.exists()) {
        selectedImage = file;
      }
    }
  }

  void logout() {
    Get.back();
  }
}