class ModelReportBadComment {
  int? id;
  String? commentId;
  String? title;
  String? contents;
  String? memberId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ModelReportBadComment(
      {this.id, this.commentId, this.title, this.contents, this.memberId, this.createdAt, this.updatedAt});

  // JSON형태에서부터 데이터를 받아온다.
  ModelReportBadComment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        commentId = json['commentId'],
        title = json['title'],
        contents = json['contents'],
        memberId = json['memberId'],
        createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
}
