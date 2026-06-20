import 'package:new_futter_app/controllers/profile_controller.dart';
import 'package:new_futter_app/helpers/theme/app_theme.dart';
import 'package:new_futter_app/helpers/theme/constant.dart';
import 'package:new_futter_app/helpers/widgets/my_button.dart';
import 'package:new_futter_app/helpers/widgets/my_container.dart';
import 'package:new_futter_app/helpers/widgets/my_spacing.dart';
import 'package:new_futter_app/helpers/widgets/my_text.dart';
import 'package:new_futter_app/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:io';
// Kırmızı çizgiyi kaldıran kritik import:
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData theme;
  late ProfileController controller;

  bool notification = true, offlineReading = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.cookifyTheme;
    controller = ProfileController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: controller,
        tag: 'profile_controller',
        builder: (controller) {
          return _buildBody();
        });
  }

  Widget _buildBody() {
    if (controller.uiLoading) {
      return Scaffold(
        body: Padding(
          padding: MySpacing.top(MySpacing.safeAreaTop(context) + 16),
          child: LoadingEffect.getSearchLoadingScreen(context),
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          padding: MySpacing.fromLTRB(
              20, MySpacing.safeAreaTop(context) + 20, 20, 20),
          children: [
            MyContainer(
              child: Row(
                children: [
                  // Profil fotoğrafına tıklanınca doğrudan galeriyi açacak şekilde güncelledik
                  InkWell(
                    onTap: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: controller.selectedImage != null
                          ? Image.file(
                        controller.selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : Image(
                        image: AssetImage(controller.user.image),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  MySpacing.width(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText.bodyLarge(controller.displayName, fontWeight: 700),
                        MySpacing.width(8),
                        MyText.bodyMedium(
                          controller.displayEmail,
                        ),
                        MySpacing.height(8),
                        MyButton.outlined(
                          onPressed: () {
                            // Alttan açılır pencere (BottomSheet) tasarlıyoruz
                            Get.bottomSheet(
                              Container(
                                padding: MySpacing.all(20),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Wrap(
                                  children: [
                                    Center(
                                      child: MyText.titleMedium("Select Profile Photo", fontWeight: 700),
                                    ),
                                    MySpacing.height(24),
                                    ListTile(
                                      leading: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                                      title: MyText.bodyMedium("Take Photo (Camera)"),
                                      onTap: () {
                                        Get.back(); // Menüyü kapat
                                        controller.pickImage(ImageSource.camera); // Kamerayı aç
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library, color: theme.colorScheme.primary),
                                      title: MyText.bodyMedium("Choose from Gallery"),
                                      onTap: () {
                                        Get.back(); // Menüyü kapat
                                        controller.pickImage(ImageSource.gallery); // Galeriyi aç
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          splashColor: theme.colorScheme.primaryContainer,
                          borderColor: theme.colorScheme.primary,
                          padding: MySpacing.xy(16, 4),
                          borderRadiusAll: 32,
                          child: MyText.bodySmall("Edit Profile", color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            MySpacing.height(24),
            MyContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText.titleMedium(
                      "Option",
                      fontWeight: 700,
                    ),
                    MySpacing.height(8),
                    SwitchListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      inactiveTrackColor: theme.colorScheme.primary.withAlpha(100),
                      activeTrackColor: theme.colorScheme.primary.withAlpha(150),
                      activeThumbColor: theme.colorScheme.primary,
                      title: MyText.bodyMedium(
                        "Notifications",
                        letterSpacing: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          notification = value;
                        });
                      },
                      value: notification,
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      visualDensity: VisualDensity.compact,
                      title: MyText.bodyMedium(
                        "Language",
                        letterSpacing: 0,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SwitchListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      inactiveTrackColor: theme.colorScheme.primary.withAlpha(100),
                      activeTrackColor: theme.colorScheme.primary.withAlpha(150),
                      activeThumbColor: theme.colorScheme.primary,
                      title: MyText.bodyMedium(
                        "Offline Reading",
                        letterSpacing: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          offlineReading = value;
                        });
                      },
                      value: offlineReading,
                    ),
                    Divider(
                      thickness: 0.8,
                    ),
                    MySpacing.height(8),
                    MyText.titleMedium(
                      "Account",
                      fontWeight: 700,
                    ),
                    MySpacing.height(8),
                    ListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      visualDensity: VisualDensity.compact,
                      title: MyText.bodyMedium(
                        "Personal Information",
                        letterSpacing: 0,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      visualDensity: VisualDensity.compact,
                      title: MyText.bodyMedium(
                        "Country",
                        letterSpacing: 0,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: MySpacing.zero,
                      visualDensity: VisualDensity.compact,
                      title: MyText.bodyMedium(
                        "Favorite Recipes",
                        letterSpacing: 0,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    MySpacing.height(16),
                    Center(
                        child: MyButton.rounded(
                          onPressed: () {
                            controller.logout();
                          },
                          elevation: 0,
                          borderRadiusAll: Constant.buttonRadius.large,
                          splashColor: theme.colorScheme.onPrimary.withAlpha(30),
                          backgroundColor: theme.colorScheme.primary,
                          child: MyText.labelLarge(
                            "LOGOUT",
                            color: theme.colorScheme.onPrimary,
                          ),
                        ))
                  ],
                )),
            MySpacing.height(24),
            MyContainer(
                color: theme.colorScheme.primaryContainer,
                padding: MySpacing.xy(16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.mic,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                    MySpacing.width(12),
                    MyText.bodySmall(
                      "Feel Free to Ask, We Ready to Help",
                      color: theme.colorScheme.primary,
                      letterSpacing: 0,
                    ),
                  ],
                )),
          ],
        ),
      );
    }
  }
}