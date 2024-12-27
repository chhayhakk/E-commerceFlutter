class Products {
  final int? id;
  final String? code;
  final String? name;
  final double? price;
  final String? image;
  final int? cat_id;
  final double? cost;
  final int? current_stock;
  final String? description;
  Products({
    this.id,
    this.name,
    this.code,
    this.price,
    this.image,
    this.cat_id,
    this.cost,
    this.current_stock,
    this.description,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      price: json['price'],
      image: json['image'],
      cat_id: json['cat_id'],
      cost: json['cost'],
      current_stock: json['current_stock'],
      description: json['description'],
    );
  }
}
