import 'package:baby_book/app/models/model_my_book.dart';
import 'package:get/get.dart';
import '../repository/my_book_repository.dart';

class BookExperienceBottomSheetController extends GetxController {
  MyBookRepository myBookRepository;

  //mybook
  final _mybook = ModelMyBook.createForObsInit().obs;

  get mybook => _mybook.value;

  set mybook(value) => _mybook.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  BookExperienceBottomSheetController({required this.myBookRepository, required ModelMyBook mybook}) {
    assert(myBookRepository != null);
    this.mybook = mybook;
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }
}
