import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:3000/products'; // use 172.x.x.x if physical device

  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> addProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  static Future<void> updateProduct(
      String id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  static Future<Map<String, dynamic>> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
