class ModelCart{
  String? image;
  String? name;
  String? productName;
  String? rating;
  double? price;
  int? quantity;
  double totalPrice(){

    return price! * quantity!;
  }

  ModelCart(this.image, this.name, this.productName, this.rating, this.price,
      this.quantity);
}