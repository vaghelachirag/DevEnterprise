import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/addBills/provider/category_provider.dart';

class ProductDropdownWidget extends ConsumerWidget {
  const ProductDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider);
    final selectedProductId = ref.watch(selectedProductProvider); // store ID
    final scannedProduct = ref.watch(scannedProductProvider); // still name?

    return productsAsync.when(
      data: (productList) {
        // If scannedProduct is a name, try to map it to an ID
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scannedProduct != null &&
              scannedProduct.isNotEmpty &&
              scannedProduct != selectedProductId) {
            final match = productList.firstWhere(
              (p) => p.productName.trim() == scannedProduct.trim(),
            );
            if (match != null) {
              ref.read(selectedProductProvider.notifier).state = match.id;
            } else {
              debugPrint("⚠️ Scanned product not found: $scannedProduct");
              ref.read(selectedProductProvider.notifier).state = null;
            }
          }
        });

        // Ensure selectedProductId is still valid
        final safeValue = productList.any((p) => p.id == selectedProductId)
            ? selectedProductId
            : null;

        if (productList.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              "select_category_first".tr(),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: safeValue, // ✅ now ID instead of name
          hint: Text("select_product".tr()),
          items: productList.map((p) {
            return DropdownMenuItem<String>(
              value: p.id, // ✅ ID as value
              child: Text(p.productName.trim()), // show name
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedProductProvider.notifier).state = value;
            debugPrint("✅ OnChanged (ID): $value");
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.inventory, color: Colors.teal.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("${"error".tr()}: $err"),
    );
  }
}
