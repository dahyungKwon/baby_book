class ModelPostFile {
  String postFileId;
  String postId;
  String? postFileUrl;
  DateTime createdAt;
  DateTime? updatedAt;

  ModelPostFile(
      {required this.postFileId, required this.postId, this.postFileUrl, required this.createdAt, this.updatedAt});

  // JSON형태에서부터 데이터를 받아온다.
  ModelPostFile.fromJson(Map<String, dynamic> json)
      : postFileId = json['postFileId'],
        postId = json['postId'],
        postFileUrl = json['postFileUrl'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
}
