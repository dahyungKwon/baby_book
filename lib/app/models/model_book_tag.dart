class ModelBookTag {
  int bookSetTagJoinId;
  int bookSetId;
  String bookSetTag;

  ModelBookTag({required this.bookSetTagJoinId, required this.bookSetId, required this.bookSetTag});

  // JSON형태에서부터 데이터를 받아온다.
  ModelBookTag.fromJson(Map<String, dynamic> json)
      : bookSetTagJoinId = json['bookSetTagJoinId'],
        bookSetId = json['bookSetId'],
        bookSetTag = json['bookSetTag'];
}
