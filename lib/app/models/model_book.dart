class ModelBook {
  int? id;
  String? name;
  String? content;
  int? targetAge;
  int? amount;
  int? saleAmount;
  DateTime? publishDate;
  String? introduceWebUrl;
  String? introduceYoutubeVideoId;
  int? likeCount;
  int? viewCount;
  int? commentCount;

  String? logo;
  String? reviewScore;
  String? publisherName;

  ModelBook({
    this.id,
    this.name,
    this.content,
    this.targetAge,
    this.amount,
    this.saleAmount,
    this.publishDate,
    this.introduceWebUrl,
    this.introduceYoutubeVideoId,
    this.likeCount,
    this.viewCount,
    this.commentCount,
    this.logo,
    this.reviewScore,
    this.publisherName,
  });

  // JSON형태에서부터 데이터를 받아온다.
  ModelBook.fromJson(Map<String, dynamic> json)
      : id = json['bookSet']['bookSetId'],
        name = json['bookSet']['bookSetName'],
        content = json['bookSet']['content'],
        targetAge = json['bookSet']['targetAge'],
        amount = json['bookSet']['amount'],
        saleAmount = json['bookSet']['saleAmount'],
        publishDate = json['bookSet']['dataTime'],
        introduceWebUrl = json['bookSet']['introduceWebUrl'],
        introduceYoutubeVideoId = json['bookSet']['introduceYoutubeVideoId'],
        likeCount = json['bookSet']['likeCount'],
        viewCount = json['bookSet']['viewCount'],
        commentCount = json['bookSet']['commentCount'];
}
