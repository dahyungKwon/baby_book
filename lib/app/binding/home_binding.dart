import 'package:get/get.dart';

import '../controller/TabHomeController.dart';
import '../repository/book_list_repository.dart';

/**
 * 현재 사용 안함
 */
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(HomeController(bookListRepository: BookListRepository()));
    Get.lazyPut<TabHomeController>(() {
      return TabHomeController(0, bookListRepository: BookListRepository());
    });
  }
}
