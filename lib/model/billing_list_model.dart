class BillingListModel {
  final int id;
  final String date;
  final String customerName;
  final int mobileNumber;
  final String city;
  final String category;
  final String productName;
  final int purchasePrice;
  final int sellingPrice;
  final int qty;
  final int totalAmount;

  BillingListModel({
    required this.id,
    required this.date,
    required this.customerName,
    required this.mobileNumber,
    required this.city,
    required this.category,
    required this.productName,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.qty,
    required this.totalAmount,
  });

  factory BillingListModel.fromJson(Map<String, dynamic> json) {
    return BillingListModel(
      id: json['Id'] ?? 0,
      date: json['Date'] ?? '',
      customerName: json['CustomerName'] ?? '',
      mobileNumber: json['MobileNumber'] ?? '',
      city: json['City'] ?? '',
      category: json['Category'] ?? '',
      productName: json['ProductName'] ?? '',
      purchasePrice: json['PurchasePrice'] ?? 0,
      sellingPrice: json['SellingPrice'] ?? 0,
      qty: json['Qty'] ?? 0,
      totalAmount: json['TotalAmount'] ?? '',
    );
  }
}
