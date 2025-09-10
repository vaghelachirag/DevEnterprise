import 'dart:convert';

import 'package:deventerprise/model/category_model.dart';
import 'package:deventerprise/model/product_list_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/add_bill_model.dart';
import '../model/billing_list_model.dart';

class ApiService {
  final String _baseUrl = dotenv.env['APPS_SCRIPT_URL'] ?? '';

  Future<List<CategoryModel>> fetchCategories() async {
    final Uri url = Uri.parse("$_baseUrl?action=getCategory");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        List<dynamic> categoriesJson = data["categories"];
        final categories = categoriesJson
            .map((e) => CategoryModel.fromJson(e))
            .toList();
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
  Future<List<ProductListModel>> fetchProductsByCategory(
    String category,
  ) async {
    final Uri url = Uri.parse(
      "$_baseUrl?action=getProductByCategory&category=$category",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        List<dynamic> categoriesJson = data["products"];
        final productList = categoriesJson
            .map((e) => ProductListModel.fromJson(e))
            .toList();
        return productList;
      } else {
        throw Exception("Failed: ${data['message']}");
      }
    } else {
      throw Exception("Network error");
    }
  }

  /* /// Submit form data
  Future<bool> submitData(Map<String, Object> data) async {
    final Uri url = Uri.parse(_baseUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 302) {
      final res = jsonDecode(response.body);
      return res["success"] == true;
    } else {
      throw Exception("Failed to submit data");
    }
  }*/

  // For Add Product
  Future<bool> submitData(AddBillModel addBill) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: addBill.toJson());
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return true;
    } else {
      throw Exception("Failed to add product");
      return false;
    }
  }

  Future<List<BillingListModel>> getBillsByDate(String date) async {
    final url = Uri.parse("$_baseUrl?action=getBill&date=$date");
    print("🔍 Fetching bills for date: $date");
    print("🔗 API URL: $url");

    final response = await http.get(url);
    print("📡 Response status: ${response.statusCode}");
    print("📄 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("📊 Parsed JSON: $json");

      // Handle different response formats
      if (json is Map<String, dynamic>) {
        // Check if response has success field
        if (json.containsKey('success') && json['success'] == false) {
          throw Exception("API Error: ${json['message'] ?? 'Unknown error'}");
        }

        // Check for data field
        if (json['data'] is List) {
          final List<dynamic> list = json['data'];
          print("📋 Found ${list.length} bills");
          return list.map((e) => BillingListModel.fromJson(e)).toList();
        }

        /* // Check if the response itself is a list
        if (json is List) {
          print("📋 Response is a list with ${json.length} items");
          return json
              .map((e) => BillingListModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }*/

        // Check for other possible data structures
        if (json.containsKey('bills') && json['bills'] is List) {
          final List<dynamic> list = json['bills'];
          print("📋 Found ${list.length} bills in 'bills' field");
          return list.map((e) => BillingListModel.fromJson(e)).toList();
        }

        throw Exception(
          "Invalid response format: Expected 'data' or 'bills' array",
        );
      } else if (json is List) {
        print("📋 Response is directly a list with ${json.length} items");
        return json.map((e) => BillingListModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format: Expected Map or List");
      }
    } else {
      throw Exception("Failed to fetch bills: HTTP ${response.statusCode}");
    }
  }

  /// Reduce product quantity
  Future<Map<String, dynamic>> reduceQty({
    required String productId,
    required int reduceBy,
  }) async {
    final uri = Uri.parse(
      "$_baseUrl?action=reduceQty&Id=$productId&reduceBy=$reduceBy",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to reduce qty: ${response.statusCode}");
    }
  }
}
