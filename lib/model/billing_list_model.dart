class BillingListModel {
  final int billId;
  final String date;
  final String address;
  final String customerName;
  final String mobileNumber;
  final int totalAmount;
  final List<BillItemModel> items;

  BillingListModel({
    required this.billId,
    required this.date,
    required this.address,
    required this.customerName,
    required this.mobileNumber,
    required this.totalAmount,
    required this.items,
  });

  factory BillingListModel.fromJson(Map<String, dynamic> json) {
    return BillingListModel(
      billId: int.tryParse(json['BillID']?.toString() ?? '0') ?? 0,
      date: json['Date']?.toString() ?? '',
      customerName: json['CustomerName']?.toString() ?? '',
      address: json['Address']?.toString() ?? '',
      mobileNumber: json['MobileNumber']?.toString() ?? '',
      totalAmount: int.tryParse(json['TotalAmount']?.toString() ?? '0') ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => BillItemModel.fromJson(item))
          .toList(),
    );
  }
}

class BillItemModel {
  final String productId;
  final String productName;
  final String category;
  final String color;
  final int price;
  final int quantity;
  final int total;

  BillItemModel({
    required this.productId,
    required this.productName,
    required this.category,
    required this.color,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }
}
