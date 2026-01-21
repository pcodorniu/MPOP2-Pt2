import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pt2flutter/data/models/product.dart';

abstract class IProductService {
  Future<Product> createProduct(Product product, String token);
  Future<List<Product>> getProducts(String token);
}

class ProductService implements IProductService {
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0dnl2dnhvbm5zZG9xb2t2aWt3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0ODE1NTQsImV4cCI6MjA4MTA1NzU1NH0.6AxDj1flnnqtBvOjoKe9_MehqBwo0kNgxLGOf4VKQ5A';
  static const String _baseUrl =
      'https://itvyvvxonnsdoqokvikw.supabase.co/rest/v1';

  @override
  Future<Product> createProduct(Product product, String token) async {
    final url = Uri.parse('$_baseUrl/products');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'apikey': _apiKey,
        'Prefer': 'return=representation',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return Product.fromJson(data.first);
    } else {
      throw Exception('Error creating product: ${response.body}');
    }
  }

  @override
  Future<List<Product>> getProducts(String token) async {
    final url = Uri.parse('$_baseUrl/products?select=*');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'apikey': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching products: ${response.body}');
    }
  }
}
