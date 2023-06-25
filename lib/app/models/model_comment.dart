class ModelComment {
  String commentId;
  String? commentParentId;
  String body;
  String commentTargetId;
  String memberId;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? expiredAt;

  ModelComment(
      {required this.commentId,
      this.commentParentId,
      required this.body,
      required this.commentTargetId,
      required this.memberId,
      required this.createdAt,
      this.updatedAt,
      this.expiredAt});

  // JSON형태에서부터 데이터를 받아온다.
  ModelComment.fromJson(Map<String, dynamic> json)
      : commentId = json['commentId'],
        commentParentId = json['commentParentId'],
        body = json['body'],
        commentTargetId = json['commentTargetId'],
        memberId = json['memberId'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        expiredAt = json['expiredAt'] != null ? DateTime.parse(json['expiredAt']) : null;
}
