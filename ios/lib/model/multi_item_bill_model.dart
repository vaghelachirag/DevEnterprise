import 'bill_item_model.dart';

class MultiItemBillModel {
  final String billId;
  final String action;
  final String billDate;
  final String customerName;
  final String mobileNumber;
  final String city;
  final List<BillItemModel> items;
  final double grandTotal;

  MultiItemBillModel({
    required this.billId,
    required this.action,
    required this.billDate,
    required this.customerName,
    required this.mobileNumber,
    required this.city,
    required this.items,
    required this.grandTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      "billId": billId,
      "action": action,
      "billDate": billDate,
      "customerName": customerName,
      "mobileNumber": mobileNumber,
      "city": city,
      "items": items.map((item) => item.toJson()).toList(),
      "grandTotal": grandTotal.toStringAsFixed(2),
    };
  }

  factory MultiItemBillModel.fromJson(Map<String, dynamic> json) {
    return MultiItemBillModel(
      billId: json["billId"] ?? "",
      action: json["action"] ?? "",
      billDate: json["billDate"] ?? "",
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      city: json["city"] ?? "",
      items: (json["items"] as List<dynamic>?)
          ?.map((item) => BillItemModel.fromJson(item))
          .toList() ?? [],
      grandTotal: double.tryParse(json["grandTotal"]?.toString() ?? "0") ?? 0,
    );
  }
}
