import 'dart:convert';
import 'package:deventerprise/model/category_model.dart';
import 'package:deventerprise/model/product_list_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = dotenv.env['APPS_SCRIPT_URL'] ?? '';

   Future<List<CategoryModel>> fetchCategories() async {
    final Uri url = Uri.parse("$_baseUrl?action=getCategory");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        List<dynamic> categoriesJson = data["categories"];
        final categories = categoriesJson.map((e) => CategoryModel.fromJson(e)).toList();
        return categories;
      } else {
        throw Exception("Failed: ${data['message']}");
      }
    } else {
      throw Exception("Network error");
    }

  }

  Future<bool> addCategory(String categoryName) async {
    final Uri url = Uri.parse("$_baseUrl?action=getCategory");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"categoryname": categoryName}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return res["success"] == true;
    } else {
      throw Exception("Failed to add category");
    }
  }

  // lib/services/api_service.dart
  Future<List<ProductListModel>> fetchProductsByCategory(String category) async {
    final Uri url = Uri.parse("$_baseUrl?action=getProductByCategory&category=$category");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        List<dynamic> categoriesJson = data["products"];
        final productList = categoriesJson.map((e) => ProductListModel.fromJson(e)).toList();
        return productList;
      } else {
        throw Exception("Failed: ${data['message']}");
      }
    } else {
      throw Exception("Network error");
    }

  }


  /// Submit form data
  Future<bool> submitData(Map<String, Object> data) async {
    final Uri url = Uri.parse(_baseUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return res["success"] == true;
    } else {
      throw Exception("Failed to submit data");
    }
  }
}
