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
      id: int.tryParse(json['Id']?.toString() ?? '0') ?? 0,
      date: json['Date']?.toString() ?? '',
      customerName: json['CustomerName']?.toString() ?? '',
      mobileNumber: int.tryParse(json['MobileNumber']?.toString() ?? '0') ?? 0,
      city: json['City']?.toString() ?? '',
      category: json['Category']?.toString() ?? '',
      productName: json['ProductName']?.toString() ?? '',
      purchasePrice: int.tryParse(json['PurchasePrice']?.toString() ?? '0') ?? 0,
      sellingPrice: int.tryParse(json['SellingPrice']?.toString() ?? '0') ?? 0,
      qty: int.tryParse(json['Qty']?.toString() ?? '0') ?? 0,
      totalAmount: int.tryParse(json['TotalAmount']?.toString() ?? '0') ?? 0,
    );
  }
}
