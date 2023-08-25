class ModelReportBadCommentRequest {
  String? commentId;
  String? title;
  String? contents;
  String? memberId;

  ModelReportBadCommentRequest({this.commentId, this.title, this.contents, this.memberId});

  // JSON형태에서부터 데이터를 받아온다.
  ModelReportBadCommentRequest.fromJson(Map<String, dynamic> json)
      : commentId = json['commentId'],
        title = json['title'],
        contents = json['contents'],
        memberId = json['memberId'];
}
