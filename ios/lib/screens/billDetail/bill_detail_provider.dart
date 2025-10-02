// providers/bill_detail_provider.dart
import 'package:flutter/material.dart';

class BillDetailProvider extends ChangeNotifier {
  String customerName = '';
  String customerMobile = '';
  String customerAddress = '';

  String ownerName = 'Dev Enterprises';
  String ownerAddress = 'B403, Near Chandkheda Bus Stand';
  String ownerMobile = '7878934042';

  List<Map<String, dynamic>> products = [];

  void setCustomerDetails(String name, String mobile, String address) {
    customerName = name;
    customerMobile = mobile;
    customerAddress = address;
    notifyListeners();
  }

  void addProduct({
    required String productName,
    required String productId,
    required int qty,
    required double price,
  }) {
    products.add({
      'name': productName,
      'id': productId,
      'qty': qty,
      'price': price,
    });
    notifyListeners();
  }

  double get totalAmount {
    return products.fold(0, (sum, item) => sum + (item['qty'] * item['price']));
  }
}
