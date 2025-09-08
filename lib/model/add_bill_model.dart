class AddBillModel {
  final String id;
  final String action;
  final String date;
  final String customerName;
  final String mobileNumber;
  final String city;
  final String category;
  final String productName;
  final String purchasePrice;
  final String sellingPrice;
  final String quantity;
  final String totalAmount;

  AddBillModel({
    required this.id,
    required this.action,
    required this.date,
    required this.customerName,
    required this.mobileNumber,
    required this.city,
    required this.category,
    required this.productName,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    required this.totalAmount,
  });

  /// Dart object → JSON (Map)
  Map<String, String> toJson() {
    return {
      "Id": id,
      "action": action,
      "Date": date,
      "CustomerName": customerName,
      "MobileNumber": mobileNumber,
      "City": city,
      "Category": category,
      "ProductName": productName,
      "PurchasePrice": purchasePrice,
      "SellingPrice": sellingPrice,
      "Qty": quantity,
      "TotalAmount": totalAmount,
    };
  }

  /// JSON → Dart object
  factory AddBillModel.fromJson(Map<String, dynamic> json) {
    return AddBillModel(
      id: json["Id"] ?? "",
      action: json["action"] ?? "",
      date: json["Date"] ?? "",
      customerName: json["CustomerName"] ?? "",
      mobileNumber: json["MobileNumber"] ?? "",
      city: json["City"] ?? "",
      category: json["Category"] ?? "",
      productName: json["ProductName"] ?? "",
      purchasePrice: json["PurchasePrice"] ?? "",
      sellingPrice: json["SellingPrice"] ?? "",
      quantity: json["Qty"] ?? "",
      totalAmount: json["TotalAmount"] ?? "",
    );
  }
}
