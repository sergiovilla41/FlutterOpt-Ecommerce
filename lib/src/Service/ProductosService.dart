import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app_optativa/src/Models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts({String? category}) async {
    var url = 'https://fakestoreapi.com/products';
    if (category != null) {
      url = 'https://fakestoreapi.com/products/category/$category';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Product> products =
          data.map((jsonProduct) => Product.fromJson(jsonProduct)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
