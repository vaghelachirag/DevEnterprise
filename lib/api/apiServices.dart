import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = dotenv.env['APPS_SCRIPT_URL'] ?? '';

   Future<List<Map<String, dynamic>>> fetchCategories() async {
    final Uri url = Uri.parse("$_baseUrl?sheet=ProductMaster");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => {
        "id": e["id"],
        "categoryname": e["categoryname"],
      })
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<bool> addCategory(String categoryName) async {
    final Uri url = Uri.parse("$_baseUrl?action=addCategory");
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
  Future<List<Map<String, dynamic>>> fetchProductsByCategory(String category) async {

    final Uri url = Uri.parse("$_baseUrl?sheet=ProductEntries&category=$category");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => {
        "id": e["id"],
        "productname": e["productname"],
        "category": e["category"],
        "price": e["price"],
        "qty": e["qty"],
      }).toList();
    } else {
      throw Exception("Failed to load products for $category");
    }
  }

}
