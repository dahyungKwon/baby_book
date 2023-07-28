import 'model_my_book_member_body.dart';

class ModelMyBookMemberResponse {
  int count;
  List<ModelMyBookMemberBody> memberList;

  ModelMyBookMemberResponse({
    required this.count,
    required this.memberList,
  });

  ModelMyBookMemberResponse.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        memberList =
            List<ModelMyBookMemberBody>.from(json['memberList'].map((item) => ModelMyBookMemberBody.fromJson(item)))
                .toList();

  static ModelMyBookMemberResponse createForObsInit() {
    return ModelMyBookMemberResponse(count: 0, memberList: []);
  }
}
