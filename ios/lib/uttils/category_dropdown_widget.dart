import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/addBills/provider/category_provider.dart';

class ProductMasterDropdown extends ConsumerWidget {
  const ProductMasterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final scannedCategory = ref.watch(scannedCategoryProvider);
    final scannedProduct = ref.watch(scannedProductProvider);


    // If scanned category exists and is valid, update selected category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scannedCategory != null &&
          scannedCategory.isNotEmpty &&
          scannedCategory != selectedCategory) {
        ref.read(selectedCategoryProvider.notifier).state = scannedCategory;
        ref.read(selectedProductProvider.notifier).state = null;
        ref.invalidate(productsByCategoryProvider);
      }
    });

    return categoriesAsync.when(
      data: (categoryList) {
        return DropdownButtonFormField<String>(
          value: selectedCategory,
          hint: Text("select_category".tr()),
          items: categoryList.map((category) {
            return DropdownMenuItem<String>(
              value: category.name.toString(),
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedCategoryProvider.notifier).state = value;
          //  ref.read(selectedProductProvider.notifier).state = null; // reset product
            if (value != null && value.isNotEmpty) {
              ref.invalidate(productsByCategoryProvider);
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.category, color: Colors.teal.shade600),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("${"error".tr()}: $err"),
    );
  }
}
