import 'package:baby_book/app/models/model_comment.dart';

class ModelCommentResponse {
  ModelComment comment;
  List<ModelComment> childComments;
  bool myComment;
  bool deleted;
  String? commentWriterNickName;
  String? timeDiffForUi;

  ModelCommentResponse(
      {required this.comment,
      required this.childComments,
      required this.myComment,
      required this.deleted,
      this.commentWriterNickName,
      this.timeDiffForUi});

  // JSON형태에서부터 데이터를 받아온다.
  ModelCommentResponse.fromJson(Map<String, dynamic> json)
      : comment = ModelComment.fromJson(json['comment']),
        childComments =
            List<ModelComment>.from(json['childComments'].map((item) => ModelComment.fromJson(item))).toList(),
        myComment = json['myComment'],
        deleted = json['deleted'],
        commentWriterNickName = json['commentWriterNickName'],
        timeDiffForUi = json['timeDiffForUi'] ?? "";
}
