class Product {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String? userId;
  final String? createdAt;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    this.userId,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'price': price,
      'description': description,
    };
    if (userId != null) {
      data['user_id'] = userId;
    }
    return data;
  }
}
