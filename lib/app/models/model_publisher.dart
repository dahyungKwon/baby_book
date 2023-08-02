class ModelPublisher {
  int publisherId;
  String publisherName;
  String? publisherWebUrl;
  String? publisherLogoUrl;

  ModelPublisher({required this.publisherId, required this.publisherName, this.publisherWebUrl, this.publisherLogoUrl});

  // JSON형태에서부터 데이터를 받아온다.
  ModelPublisher.fromJson(Map<String, dynamic> json)
      : publisherId = json['publisherId'],
        publisherName = json['publisherName'],
        publisherWebUrl = json['publisherWebUrl'],
        publisherLogoUrl = json['publisherLogoUrl'];
}
