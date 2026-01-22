import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pt2flutter/data/models/product.dart';
import 'package:pt2flutter/config/app_config.dart';

abstract class IProductService {
  Future<Product> createProduct(Product product, String token);
  Future<List<Product>> getProducts(String token);
}

class ProductService implements IProductService {
  @override
  Future<Product> createProduct(Product product, String token) async {
    final url = Uri.parse('${AppConfig.restUrl}/products');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'apikey': AppConfig.anonKey,
        'Prefer': 'return=representation',
        'Accept': 'application/vnd.pgrst.object+json',
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
    final url = Uri.parse('${AppConfig.restUrl}/products?select=*');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'apikey': AppConfig.anonKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching products: ${response.body}');
    }
  }
}
