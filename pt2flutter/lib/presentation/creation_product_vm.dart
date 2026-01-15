import 'package:flutter/material.dart';
import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/data/repositories/product_repository.dart';

class CreationProductViewModel extends ChangeNotifier {
  final IProductRepository productRepository;

  CreationProductViewModel({required this.productRepository});

  Future<Product> createProduct(Product product) async {
    return await productRepository.createProduct(product);
  }
}
