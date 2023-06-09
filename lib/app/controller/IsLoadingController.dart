import 'package:get/get.dart';

class IsLoadingController extends GetxController {
  static IsLoadingController get to => Get.find();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  void setIsLoading(bool value) => _isLoading.value = value;
}