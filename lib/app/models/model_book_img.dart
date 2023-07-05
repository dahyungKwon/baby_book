class ModelBookImg {
  int bookSetImgId;
  int bookSetId;
  String bookSetImgUrl;
  DateTime createdAt;
  DateTime? updatedAt;

  ModelBookImg(
      {required this.bookSetImgId,
      required this.bookSetId,
      required this.bookSetImgUrl,
      required this.createdAt,
      this.updatedAt});

  // JSON형태에서부터 데이터를 받아온다.
  ModelBookImg.fromJson(Map<String, dynamic> json)
      : bookSetImgId = json['bookSetImgId'],
        bookSetId = json['bookSetId'],
        bookSetImgUrl = json['bookSetImgUrl'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
}
