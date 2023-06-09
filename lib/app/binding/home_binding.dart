import 'package:get/get.dart';

import '../controller/HomeController.dart';
import '../repository/book_list_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(HomeController(bookListRepository: BookListRepository()));
    Get.lazyPut<HomeController>(() {
      return HomeController(bookListRepository: BookListRepository());
    });
  }
}
