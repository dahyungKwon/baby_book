import 'package:get/get.dart';

/**
 * 현재 안씀
 *
    Obx(
      //isLoading(obs)가 변경되면 다시 그림.
          () => Offstage(
        offstage: !controller.isLoading, // isLoading이 false면 감추기
        child: const Stack(children: <Widget>[
          //다시 stack
          Opacity(
            //뿌옇게~
            opacity: 0.5, //0.5만큼~
            child: ModalBarrier(dismissible: false, color: Colors.black), //클릭 못하게
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ]),
      ),
    ),
 */
class IsLoadingController extends GetxController {
  static IsLoadingController get to => Get.find();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  void setIsLoading(bool value) => _isLoading.value = value;
}
