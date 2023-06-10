import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final _tabIndex = 0.obs;

  HomeScreenController(int tabIndex) {
    this.tabIndex = tabIndex;
  }

  get tabIndex => _tabIndex.value;

  set tabIndex(value) => _tabIndex.value = value;
}
