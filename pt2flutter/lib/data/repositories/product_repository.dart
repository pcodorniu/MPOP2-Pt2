import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/data/services/product_services.dart';

abstract class IProductRepository {
  Future<Product> createProduct(Product product, String token);
  Future<List<Product>> getProducts(String token);
}

class ProductRepository implements IProductRepository {
  final IProductService productService;

  ProductRepository({required this.productService});

  @override
  Future<Product> createProduct(Product product, String token) async {
    return await productService.createProduct(product, token);
  }

  @override
  Future<List<Product>> getProducts(String token) async {
    return await productService.getProducts(token);
  }
}
