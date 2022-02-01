class Crypto {
  String price;
  String name;
  String symbol;
  String image;

  Crypto(this.price, this.name, this.symbol, this.image);

  Crypto.fromJson(Map<String, dynamic> json)
    : price = json['current_price'].toString(),
      name = json["name"],
      symbol = json['symbol'],
      image = json['image'];

  Map<String, dynamic> toJson() => {
    'price' : price,
    'name' : name,
    'symbol' : symbol,
    'image' : image
  };

}