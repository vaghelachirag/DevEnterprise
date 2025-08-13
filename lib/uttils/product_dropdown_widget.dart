import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/addBills/provider/category_provider.dart';

class ProductDropdownWidget extends ConsumerWidget {
  const ProductDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider);
    final selectedProduct = ref.watch(selectedProductProvider);

    return productsAsync.when(
      data: (productList) {

        final productNames = productList.map((p) => p["productname"]).toList();
        final safeValue = productNames.contains(selectedProduct) ? selectedProduct : null;

        return DropdownButtonFormField<String>(
          value: safeValue,
          hint: const Text("Select Product"),
          items: productList.map((product) {
            return DropdownMenuItem<String>(
              value: product["productname"],
              child: Text(product["productname"]),
            );
          }).toList(),
          onChanged: (value) {
          //  ref.read(selectedProductProvider.notifier).state = value;
            print("OnChanged"+value.toString());
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("Error: $err"),
    );
  }
}
