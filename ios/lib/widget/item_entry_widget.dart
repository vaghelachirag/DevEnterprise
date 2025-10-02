import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../model/bill_item_model.dart';
import '../screens/addBills/provider/category_provider.dart';
import '../uttils/category_dropdown_widget.dart';
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

  void _showQrScannerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'scan_qr_code'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: SizedBox(width: 350, height: 300, child: _mobileScanner(ctx)),
      ),
    );
  }

  Widget _mobileScanner(BuildContext dialogContext) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
        onDetect: (BarcodeCapture barcode) {
          final String? code = barcode.barcodes.first.rawValue;
          if (code != null) {
            try {
              final Map<String, dynamic> productData = jsonDecode(code);

              final String category =
                  productData['category']?.toString() ??
                  productData['productCategory']?.toString() ??
                  '';
              final String productId =
                  productData['productId']?.toString() ?? '';

              if (category.isNotEmpty) {
                ref.read(selectedCategoryProvider.notifier).state = category;
              }
              if (productId.isNotEmpty) {
                ref.read(selectedProductProvider.notifier).state = productId;
              }

              _priceController.text =
                  productData['price']?.toString() ?? _priceController.text;
              _quantityController.text =
                  productData['qty']?.toString() ?? _quantityController.text;

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('qr_code_scanned_successfully'.tr())),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('invalid_qr_code_data'.tr())),
              );
            }
          }
        },
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 20,
      ), // reduced padding
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'add_item'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    tooltip: 'scan_qr'.tr(),
                    onPressed: _showQrScannerDialog,
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'category'.tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              // Category Dropdown
              ProductMasterDropdown(),
              const SizedBox(height: 12),

              // Product Dropdown
              Text(
                'product'.tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ProductDropdownWidget(),
              const SizedBox(height: 12),

              // Color Dropdown
              Text(
                'color'.tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value:
                    _colorController.text.isNotEmpty &&
                        colorOptions.contains(_colorController.text)
                    ? _colorController.text
                    : null,
                items: colorOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.tr()),
                  );
                }).toList(),
                onChanged: (value) {
                  _colorController.text = value ?? '';
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'required'.tr() : null,
              ),
              const SizedBox(height: 12),

              // Price + Quantity Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'price'.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'required'.tr() : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'quantity'.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'required'.tr() : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: Text('cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addItem,
                      child: Text('add_item'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
