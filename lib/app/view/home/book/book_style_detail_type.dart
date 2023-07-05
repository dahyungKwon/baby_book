import 'book_style_type.dart';

enum BookStyleDetailType {
  board("BOARD", "보드북"),
  hardcover("HARDCOVER", "하드커버북"),
  paper("PAPER", "페이퍼북"),
  flap("FLAP", "플랩북"),
  sound("SOUND", "사운드북"),
  popup("POPUP", "팝업북"),
  touch("TOUCH", "촉감북"),
  smell("SMELL", "향기책"),
  folding("FOLDING", "병풍책"),
  etc("ETC", "기타");

  final String code;
  final String desc;

  const BookStyleDetailType(this.code, this.desc);

  static BookStyleDetailType findByCode(String code) {
    return BookStyleDetailType.values.firstWhere((value) => value.code == code, orElse: () => BookStyleDetailType.etc);
  }

  static List<String> findDescList() {
    return BookStyleDetailType.values.map((e) => e.desc).toList();
  }
}
