import 'package:flutter/material.dart';
import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/data/repositories/product_repository.dart';

class ProductListViewModel extends ChangeNotifier {
  final IProductRepository productRepository;

  ProductListViewModel({required this.productRepository});

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await productRepository.getProducts(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
