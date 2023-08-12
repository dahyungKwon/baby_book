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

  /// 아직사용안함
  String? postTag1;
  String? postTag2;
  String? postTag3;
  List<String> postTagList = [];

  int? bookIdTag1;
  int? bookIdTag2;
  int? bookIdTag3;
  List<int> bookIdTagList = [];

  bool liked = false;
  bool disliked = false;
  bool bookmark = false;

  String nickName;
  String? createdAtToString;
  String? timeDiffForUi;

  List<ModelPostFile> postFileList = [];

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
      this.bookIdTag1,
      this.bookIdTag2,
      this.bookIdTag3,
      this.liked = false,
      this.disliked = false,
      this.bookmark = false,
      required this.nickName,
      this.createdAtToString,
      this.timeDiffForUi,
      this.postFileList = const []}) {
    postTagList = initPostTagList(postTag1, postTag2, postTag3);
    bookIdTagList = initBookTagList(bookIdTag1, bookIdTag2, bookIdTag3);
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

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'postType': postType,
        'memberId': memberId,
        'title': title,
        'contents': contents,
        'externalLink': externalLink,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'viewCount': viewCount,
        'commentCount': commentCount,
        'bookmarkCount': bookmarkCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'postTag1': postTag1,
        'postTag2': postTag2,
        'postTag3': postTag3,
        'postTagList': postTagList,
        'bookIdTag1': bookIdTag1,
        'bookIdTag2': bookIdTag2,
        'bookIdTag3': bookIdTag3,
        'bookIdTagList': bookIdTagList,
        'liked': liked,
        'disliked': disliked,
        'bookmark': bookmark,
        'nickName': nickName,
        'createdAtToString': createdAtToString,
        'timeDiffForUi': timeDiffForUi,
        'postFileList': postFileList,
      };

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
        bookIdTag1 = json['bookIdTag1'],
        bookIdTag2 = json['bookIdTag2'],
        bookIdTag3 = json['bookIdTag3'],
        bookIdTagList = initBookTagList(json['bookIdTag1'], json['bookIdTag2'], json['bookIdTag3']),
        liked = json['liked'] ?? false,
        disliked = json['disliked'] ?? false,
        bookmark = json['bookmark'] ?? false,
        nickName = json['nickName'] ?? "",
        createdAtToString = json['createdAtToString'] ?? "",
        timeDiffForUi = json['timeDiffForUi'] ?? "",
        postFileList = json['postFileList'] == null
            ? []
            : List<ModelPostFile>.from(json['postFileList'].map((item) => ModelPostFile.fromJson(item))).toList();

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

    bookIdTag1 = selectedPost.bookIdTag1;
    bookIdTag2 = selectedPost.bookIdTag2;
    bookIdTag3 = selectedPost.bookIdTag3;
    bookIdTagList = initBookTagList(bookIdTag1, bookIdTag2, bookIdTag3);

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

  static List<int> initBookTagList(int? bookIdTag1, int? bookIdTag2, int? bookIdTag3) {
    List<int> list = [];

    if (bookIdTag1 != null) {
      list.add(bookIdTag1!);
    }

    if (bookIdTag2 != null) {
      list.add(bookIdTag2!);
    }

    if (bookIdTag3 != null) {
      list.add(bookIdTag3!);
    }

    return list;
  }

  bool existExternalLink() {
    return externalLink != null && externalLink!.isNotEmpty;
  }
}
