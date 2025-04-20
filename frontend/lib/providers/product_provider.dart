import 'package:flutter/material.dart';
import '../api_service.dart';

class ProductProvider with ChangeNotifier {
  List<dynamic> _products = [];

  List<dynamic> get products => _products;

  Future<void> fetchProducts() async {
    _products = await ApiService.fetchProducts();
    notifyListeners();
  }

  Future<void> addProduct(Map<String, dynamic> newProduct) async {
    await ApiService.addProduct(newProduct);
    await fetchProducts(); // refresh list
  }

  Future<void> updateProduct(
      String id, Map<String, dynamic> updatedProduct) async {
    await ApiService.updateProduct(id, updatedProduct);
    await fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await ApiService.deleteProduct(id);
    await fetchProducts();
  }

  Future<Map<String, dynamic>> getProductById(String id) async {
    return await ApiService.fetchProductById(id);
  }
}
