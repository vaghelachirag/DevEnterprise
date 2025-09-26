class BillItemModel {
  final String productId;
  final String productName;
  final String category;
  final String color;
  final double price;
  final int quantity;
  final double totalAmount;

  BillItemModel({
    required this.productId,
    required this.productName,
    required this.category,
    required this.color,
    required this.price,
    required this.quantity,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "category": category,
      "color": color,
      "price": price.toStringAsFixed(2),
      "quantity": quantity,
      "totalAmount": totalAmount.toStringAsFixed(2),
    };
  }

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      productId: json["productId"]?.toString() ?? "",
      productName: json["productName"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
      color: json["color"]?.toString() ?? "",
      price: _toDouble(json["price"]),
      quantity: _toInt(json["quantity"]),
      totalAmount: _toDouble(json["totalAmount"]),
    );
  }

  BillItemModel copyWith({
    String? productId,
    String? productName,
    String? category,
    String? color,
    double? price,
    int? quantity,
    double? totalAmount,
  }) {
    return BillItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      color: color ?? this.color,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

double _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? "0") ?? 0.0;
}

int _toInt(dynamic v) {
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? "0") ?? 0;
}
