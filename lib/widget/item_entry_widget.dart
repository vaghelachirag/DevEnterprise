import 'package:deventerprise/uttils/category_dropdown_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/bill_item_model.dart';
import '../screens/addBills/provider/category_provider.dart';
import '../uttils/product_dropdown_widget.dart';

class ItemEntryWidget extends ConsumerStatefulWidget {
  final Function(BillItemModel) onAddItem;
  final VoidCallback onCancel;

  const ItemEntryWidget({
    super.key,
    required this.onAddItem,
    required this.onCancel,
  });

  @override
  ConsumerState<ItemEntryWidget> createState() => _ItemEntryWidgetState();
}

class _ItemEntryWidgetState extends ConsumerState<ItemEntryWidget> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> colorOptions = [
    'black',
    'white',
    'silver',
    'gold',
    'blue',
    'red',
    'green',
    'gray',
    'pink',
    'purple',
    'yellow',
    'orange',
    'brown',
    'other',
  ];

  double get _liveTotal {
    final price = double.tryParse(_priceController.text) ?? 0;
    final qty = int.tryParse(_quantityController.text) ?? 1;
    return price * qty;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) return;

    final selectedProduct = ref.read(selectedProductProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);

    if (selectedProduct == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_select_product_and_category'.tr())),
      );
      return;
    }

    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final totalAmount = price * quantity;

    final item = BillItemModel(
      productId: selectedProduct,
      productName: _getProductName(selectedProduct),
      category: selectedCategory,
      color: _colorController.text,
      price: price,
      quantity: quantity,
      totalAmount: totalAmount,
    );

    widget.onAddItem(item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    InputDecoration _decor({String? hint, Widget? prefixIcon}) {
      return InputDecoration(
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.6),
        hintText: hint,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.add_box_rounded, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          "Add New Item".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.teal,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Divider(),

                    // Category Dropdown
                    const SizedBox(height: 8),
                    const ProductMasterDropdown(),
                    const SizedBox(height: 12),

                    // Product Dropdown
                    const ProductDropdownWidget(),
                    const SizedBox(height: 12),

                    // Color Dropdown
                    DropdownButtonFormField<String>(
                      value:
                          _colorController.text.isNotEmpty &&
                              colorOptions.contains(_colorController.text)
                          ? _colorController.text
                          : null,
                      items: colorOptions
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.tr())),
                          )
                          .toList(),
                      onChanged: (val) => _colorController.text = val ?? '',
                      decoration: _decor(
                        hint: "Select Color".tr(),
                        prefixIcon: const Icon(Icons.palette),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "required".tr() : null,
                    ),
                    const SizedBox(height: 12),

                    // Price + Quantity
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: _decor(
                              hint: "0.00",
                              prefixIcon: const Icon(
                                Icons.sell_outlined,
                                color: Colors.teal,
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "required".tr()
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: _decor(
                              hint: "0",
                              prefixIcon: const Icon(
                                Icons.numbers_outlined,
                                color: Colors.teal,
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "required".tr()
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),

                    // Live Total Preview
                    const SizedBox(height: 14),
                    Text(
                      "Total: ₹${_liveTotal.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.onCancel,
                            icon: const Icon(Icons.close),
                            label: Text("Cancel".tr()),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addItem,
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text("Add Item".tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Top-right close button
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: widget.onCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductName(String productId) {
    final productsAsync = ref.read(productsByCategoryProvider);
    return productsAsync.maybeWhen(
      data: (list) {
        try {
          return list.firstWhere((p) => p.id == productId).productName.trim();
        } catch (_) {
          return '';
        }
      },
      orElse: () => '',
    );
  }
}
