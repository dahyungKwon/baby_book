import 'dart:ui';

class ModelBooking {
  String? image;
  String? name;
  String? date;
  String? rating;
  double? price;
  String? owner;
  String? tag;
  int? bgColor;
  Color? textColor;


  ModelBooking(this.image, this.name, this.date, this.rating, this.price,
      this.owner, this.tag, this.bgColor, this.textColor);

  ModelBooking.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        date = json['date'],
        rating = json['rating'],
        price = json['price'],
        owner = json['owner'],
        tag = json['tag'],
        bgColor = json['bgColor'],
        textColor = json['textColor'];

  Map<String, dynamic> toJson() => {
        'textColor': textColor,
        'bgColor': bgColor,
        'tag': tag,
        'owner': owner,
        'price': price,
        'rating': rating,
        'date': date,
        'image': image,
        'name': name,
      };
}
