import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/addBills/provider/category_provider.dart';

class ProductDropdownWidget extends ConsumerWidget {
  const ProductDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider);
    final selectedProduct = ref.watch(selectedProductProvider);
    final scannedProduct = ref.watch(scannedProductProvider);

    return productsAsync.when(
      data: (productList) {
        final productNames = productList
            .map((p) => p.productName.trim())
            .toList();
        // Auto-select scanned product if valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scannedProduct != null &&
              scannedProduct.isNotEmpty &&
              scannedProduct != selectedProduct) {
            if (productNames.contains(scannedProduct.trim())) {
              ref.read(selectedProductProvider.notifier).state = scannedProduct
                  .trim();
            } else {
              debugPrint("⚠️ Scanned product not found: $scannedProduct");
              ref.read(selectedProductProvider.notifier).state = null;
            }
          }
        });

        // Ensure value is valid, else reset
        final safeValue = productNames.contains(selectedProduct)
            ? selectedProduct
            : null;

        if (productNames.isEmpty) {
          return Text("select_category_first".tr());
        }

        return DropdownButtonFormField<String>(
          value: safeValue,
          hint: Text("select_product".tr()),
          items: productNames.map((name) {
            return DropdownMenuItem<String>(value: name, child: Text(name));
          }).toList(),
          onChanged: (value) {
            ref.read(selectedProductProvider.notifier).state = value;
            debugPrint("✅ OnChanged: $value");
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("${"error".tr()}: $err"),
    );
  }
}
