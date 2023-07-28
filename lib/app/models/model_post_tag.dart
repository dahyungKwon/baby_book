import 'package:baby_book/app/models/model_post.dart';

class ModelPostTag {
  String? tag;
  int? bookId;
  int count;
  List<ModelPost> postList;

  ModelPostTag({this.tag, this.bookId, required this.count, required this.postList});

  static ModelPostTag createForObsInit() {
    return ModelPostTag(tag: "", bookId: 0, count: 0, postList: []);
  }

  // JSON형태에서부터 데이터를 받아온다.
  ModelPostTag.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        bookId = json['bookId'],
        count = json['count'],
        postList = List<ModelPost>.from(json['postList'].map((item) => ModelPost.fromJson(item))).toList();
}
