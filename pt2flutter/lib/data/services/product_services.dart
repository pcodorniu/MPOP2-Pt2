import 'package:pt2flutter/data/models/product.dart';

abstract class IProductService {
  Future<Product> createProduct(Product product);
}

class ProductService implements IProductService {
  Future<Product> createProduct(Product product) async {
    return Product(id: 1, name: 'Product 1', price: 1.0);
  }
}
