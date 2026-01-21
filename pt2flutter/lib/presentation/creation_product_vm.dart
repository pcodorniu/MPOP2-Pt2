import 'package:flutter/material.dart';
import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/data/repositories/product_repository.dart';

class CreationProductViewModel extends ChangeNotifier {
  final IProductRepository productRepository;

  CreationProductViewModel({required this.productRepository});

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> createProduct({
    required String title,
    required double price,
    required String description,
    required String userId,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final product = Product(
        title: title,
        price: price,
        description: description,
        userId: userId,
      );
      await productRepository.createProduct(product, token);
      _successMessage = 'Product created successfully!';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
