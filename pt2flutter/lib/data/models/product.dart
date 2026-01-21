class Product {
  final int? id;
  final String name;
  final double price;
  final String? userId;

  Product({this.id, required this.name, required this.price, this.userId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      userId: json['user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name, 'price': price};
    if (userId != null) {
      data['user_id'] = userId;
    }
    return data;
  }
}
