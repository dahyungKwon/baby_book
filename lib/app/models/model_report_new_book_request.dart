class ModelReportNewBookRequest {
  String? title;
  String? contents;
  String? memberId;

  ModelReportNewBookRequest({this.title, this.contents, this.memberId});

  // JSON형태에서부터 데이터를 받아온다.
  ModelReportNewBookRequest.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        contents = json['contents'],
        memberId = json['memberId'];
}
