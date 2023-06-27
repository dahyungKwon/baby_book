import 'package:baby_book/app/view/community/post_type.dart';

import 'model_post_file.dart';

class ModelPost {
  String postId;
  PostType postType;
  String memberId;
  String title;
  String contents;
  String? externalLink;

  int likeCount = 0;
  int dislikeCount = 0;
  int viewCount = 0;
  int commentCount = 0;
  int bookmarkCount = 0;

  DateTime createdAt;
  DateTime? updatedAt;

  String? postTag1;
  String? postTag2;
  String? postTag3;
  List<String> postTagList = [];

  bool liked = false;
  bool disliked = false;
  bool bookmark = false;

  String nickName;
  String? createdAtToString;
  String? timeDiffForUi;

  List<ModelPostFile> postFileList;

  ModelPost(
      {required this.postId,
      required this.postType,
      required this.memberId,
      required this.title,
      required this.contents,
      this.externalLink,
      this.likeCount = 0,
      this.dislikeCount = 0,
      this.viewCount = 0,
      this.commentCount = 0,
      this.bookmarkCount = 0,
      required this.createdAt,
      this.updatedAt,
      this.postTag1,
      this.postTag2,
      this.postTag3,
      this.liked = false,
      this.disliked = false,
      this.bookmark = false,
      required this.nickName,
      this.createdAtToString,
      this.timeDiffForUi,
      this.postFileList = const []}) {
    postTagList = initPostTagList(postTag1, postTag2, postTag3);
  }

  static ModelPost createModelPostForObsInit() {
    return ModelPost(
        postId: "",
        postType: PostType.none,
        memberId: "",
        title: "",
        contents: "",
        createdAt: DateTime.now(),
        nickName: "");
  }

  // JSON형태에서부터 데이터를 받아온다.
  ModelPost.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        postType = PostType.findByCode(json['postType']),
        memberId = json['memberId'],
        title = json['title'],
        contents = json['contents'],
        externalLink = json['externalLink'],
        likeCount = json['likeCount'],
        dislikeCount = json['dislikeCount'],
        viewCount = json['viewCount'],
        commentCount = json['commentCount'],
        bookmarkCount = json['bookmarkCount'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        postTag1 = json['postTag1'],
        postTag2 = json['postTag2'],
        postTag3 = json['postTag3'],
        postTagList = initPostTagList(json['postTag1'], json['postTag2'], json['postTag3']),
        liked = json['liked'],
        disliked = json['disliked'],
        bookmark = json['bookmark'],
        nickName = json['nickName'] ?? "",
        createdAtToString = json['createdAtToString'] ?? "",
        timeDiffForUi = json['timeDiffForUi'] ?? "",
        postFileList =
            List<ModelPostFile>.from(json['postFileList'].map((item) => ModelPostFile.fromJson(item))).toList();

  copyWith({required ModelPost selectedPost}) {
    postId = selectedPost.postId;
    postType = selectedPost.postType;
    memberId = selectedPost.memberId;
    title = selectedPost.title;
    contents = selectedPost.contents;
    externalLink = selectedPost.externalLink;
    likeCount = selectedPost.likeCount;
    dislikeCount = selectedPost.dislikeCount;
    viewCount = selectedPost.viewCount;
    commentCount = selectedPost.commentCount;
    bookmarkCount = selectedPost.bookmarkCount;
    createdAt = selectedPost.createdAt;
    updatedAt = selectedPost.updatedAt;
    postTag1 = selectedPost.postTag1;
    postTag2 = selectedPost.postTag2;
    postTag3 = selectedPost.postTag3;
    postTagList = initPostTagList(postTag1, postTag2, postTag3);

    liked = selectedPost.liked;
    disliked = selectedPost.disliked;
    bookmark = selectedPost.bookmark;
    nickName = selectedPost.nickName;
    createdAtToString = selectedPost.createdAtToString;
    timeDiffForUi = selectedPost.timeDiffForUi;
    postFileList = selectedPost.postFileList;
  }

  static List<String> initPostTagList(String? postTag1, String? postTag2, String? postTag3) {
    List<String> list = [];

    if (postTag1 != null && postTag1 != "") {
      list.add(postTag1!);
    }

    if (postTag2 != null && postTag2 != "") {
      list.add(postTag2!);
    }

    if (postTag3 != null && postTag3 != "") {
      list.add(postTag3!);
    }

    return list;
  }

  bool existExternalLink() {
    return externalLink != null && externalLink!.isNotEmpty;
  }
}
