class ModelBook{
  int id;
  String name;
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

  ModelBook({
    required this.id,
    required this.name,
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
  });

  // JSON형태에서부터 데이터를 받아온다.
  ModelBook.fromJson({required Map<dynamic, dynamic> json})
      : id = json['bookSet']['bookSetId'] ?? 0,
        name = json['bookSet']['bookSetName'] ?? '',
        content = json['bookSet']['content'] ?? '',
        targetAge = json['bookSet']['targetAge'] ?? 0,
        amount = json['bookSet']['amount'] ?? 0,
        saleAmount = json['bookSet']['saleAmount'] ?? 0,
        publishDate = json['bookSet']['dataTime'] ?? DateTime.now(),
        introduceWebUrl = json['bookSet']['introduceWebUrl'] ?? '',
        introduceYoutubeVideoId = json['bookSet']['introduceYoutubeVideoId'] ?? '',
        likeCount = json['bookSet']['likeCount'] ?? 0,
        viewCount = json['bookSet']['viewCount'] ?? 0,
        commentCount = json['bookSet']['commentCount'] ?? 0;
}