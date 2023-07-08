class ModelBook {
  int? id;
  String? name;
  String? content;
  int? targetAge;

  int? targetMonth;
  int? targetStartMonth;
  int? targetEndMonth;

  int? amount;
  int? saleAmount;

  String? configuration;
  String? additionalConfiguration;

  DateTime? publishDate;
  String? introduceWebUrl;
  String? introduceYoutubeVideoId;
  int? recommendUsedBookCount;
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
    this.targetMonth,
    this.targetStartMonth,
    this.targetEndMonth,
    this.amount,
    this.saleAmount,
    this.configuration,
    this.additionalConfiguration,
    this.publishDate,
    this.introduceWebUrl,
    this.introduceYoutubeVideoId,
    this.recommendUsedBookCount,
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
        targetMonth = json['bookSet']['targetMonth'],
        targetStartMonth = json['bookSet']['targetStartMonth'],
        targetEndMonth = json['bookSet']['targetEndMonth'],
        amount = json['bookSet']['amount'],
        saleAmount = json['bookSet']['saleAmount'],
        configuration = json['bookSet']['configuration'],
        additionalConfiguration = json['bookSet']['additionalConfiguration'],
        publishDate = json['bookSet']['dataTime'],
        introduceWebUrl = json['bookSet']['introduceWebUrl'],
        introduceYoutubeVideoId = json['bookSet']['introduceYoutubeVideoId'],
        recommendUsedBookCount = json['bookSet']['recommendUsedBookCount'],
        likeCount = json['bookSet']['likeCount'],
        viewCount = json['bookSet']['viewCount'],
        commentCount = json['bookSet']['commentCount'];
}
