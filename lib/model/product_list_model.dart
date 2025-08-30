class ProductByCategoryResponse {
  final bool success;
  final String category;
  final List<ProductListModel> products;

  ProductByCategoryResponse({
    required this.success,
    required this.category,
    required this.products,
  });

  factory ProductByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ProductByCategoryResponse(
      success: json['success'] ?? false,
      category: json['category'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductListModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ProductListModel {
  final String id;
  final String category;
  final String productName;
  final double purchasePrice;
  final int qty;

  ProductListModel({
    required this.id,
    required this.category,
    required this.productName,
    required this.purchasePrice,
    required this.qty,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      productName: json['productName'] ?? '',
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
      qty: json['qty'] ?? 0,
    );
  }
}
