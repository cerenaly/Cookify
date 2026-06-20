import 'package:new_futter_app/models/category.dart';
import 'package:new_futter_app/models/showcase.dart';
import 'package:get/get.dart';

class ShowcaseController extends GetxController {
  bool showLoading = true, uiLoading = true;
  late List<Showcase> showcases;
  late List<Category> categories;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    showcases = await Showcase.getDummyList();
    categories = Category.getList();
    await Future.delayed(Duration(seconds: 1));
    showLoading = false;
    uiLoading = false;
    update();
  }
}
