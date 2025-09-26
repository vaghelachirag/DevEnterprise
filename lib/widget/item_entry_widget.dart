import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../model/bill_item_model.dart';
import '../uttils/category_dropdown_widget.dart';
import '../uttils/product_dropdown_widget.dart';
import '../screens/addBills/provider/category_provider.dart';

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
    'black', 'white', 'silver', 'gold', 'blue', 'red', 'green',
    'gray', 'pink', 'purple', 'yellow', 'orange', 'brown', 'other',
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
        title: Text('scan_qr_code'.tr()),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: _mobileScanner(ctx),
        ),
      ),
    );
  }

  Widget _mobileScanner(BuildContext dialogContext) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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

                  // Update selected category and product (expects product ID)
                  final String category =
                      productData['category']?.toString() ??
                      productData['productCategory']?.toString() ?? '';
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
                    SnackBar(
                      content: Text('qr_code_scanned_successfully'.tr()),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('invalid_qr_code_data'.tr())),
                  );
                }
              }
            },
          ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'add_item'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
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
              const SizedBox(height: 16),
              
              // Category Dropdown
              ProductMasterDropdown(),
              const SizedBox(height: 16),
              
              // Product Dropdown
              ProductDropdownWidget(),
              const SizedBox(height: 16),
              
              // Color Dropdown
              DropdownButtonFormField<String>(
                value: _colorController.text.isNotEmpty && colorOptions.contains(_colorController.text)
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
                  labelText: 'color'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'required'.tr() : null,
              ),
              const SizedBox(height: 16),
              
              // Price and Quantity Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'price'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'required'.tr() : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'quantity'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'required'.tr() : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: Text('cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
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
