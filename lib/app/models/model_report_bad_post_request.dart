class ModelReportBadPostRequest {
  String? postId;
  String? title;
  String? contents;
  String? memberId;

  ModelReportBadPostRequest({this.postId, this.title, this.contents, this.memberId});

  // JSON형태에서부터 데이터를 받아온다.
  ModelReportBadPostRequest.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        title = json['title'],
        contents = json['contents'],
        memberId = json['memberId'];
}
