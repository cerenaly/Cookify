import 'package:new_futter_app/models/recipe.dart';
import 'package:new_futter_app/views/recipe_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  bool showLoading = true, uiLoading = true;
  late Recipe recipe;
  late List<Recipe> trendingRecipe;
  String userName = "Den";

  Future<void> loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('user_name');
    if (savedName != null && savedName.isNotEmpty) {
      userName = savedName;
      update(); // Arayüzün ismi yenilemesi için GetX'i tetikliyoruz
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
    loadUserName();
  }

  void fetchData() async {
    recipe = await Recipe.getOne();
    trendingRecipe = await Recipe.getDummyList();
    await Future.delayed(Duration(seconds: 1));
    showLoading = false;
    uiLoading = false;
    update();
  }

  void goToRecipeScreen() {
    Get.to(RecipeScreen());
    // Navigator.of(context, rootNavigator: true)
    //     .push(MaterialPageRoute(builder: (context) => RecipeScreen()));
  }
}
