
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  // Base URL Fake Store API.
  static const String baseUrl = 'https://fakestoreapi.com';

  // Mengambil seluruh daftar produk.
  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) {
        return Product.fromJson(item);
      }).toList();
    } else {
      throw Exception('Gagal mengambil daftar produk');
    }
  }

  // Mengambil detail produk berdasarkan ID.
  static Future<Product> getProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return Product.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail produk');
    }
  }
}
