import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/data/services/product_services.dart';

abstract class IProductRepository {
  Future<Product> createProduct(Product product);
}

class ProductRepository implements IProductRepository {
  final IProductService productService;

  ProductRepository({required this.productService});

  @override
  Future<Product> createProduct(Product product) async {
    return await productService.createProduct(product);
  }
}
