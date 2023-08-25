class ModelReportBadPost {
  int? id;
  String? postId;
  String? title;
  String? contents;
  String? memberId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ModelReportBadPost({this.id, this.postId, this.title, this.contents, this.memberId, this.createdAt, this.updatedAt});

  // JSON형태에서부터 데이터를 받아온다.
  ModelReportBadPost.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        postId = json['postId'],
        title = json['title'],
        contents = json['contents'],
        memberId = json['memberId'],
        createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
}
