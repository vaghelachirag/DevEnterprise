import 'dart:convert';

import 'package:deventerprise/screens/addBills/provider/category_provider.dart';
import 'package:deventerprise/uttils/product_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../uttils/category_dropdown_widget.dart';
import 'addBillProvider.dart';

class AddBillsPage extends ConsumerWidget {
  AddBillsPage({super.key});

  final List<String> colorOptions = [
    'Black', 'White', 'Silver', 'Gold', 'Blue', 'Red', 'Green', 'Gray',
    'Pink', 'Purple', 'Yellow', 'Orange', 'Brown', 'Other',
  ];


  Widget buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> options,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        // If the controller has text and it exists in the options list, use it as the selected value
        value: (controller.text.isNotEmpty && options.contains(controller.text))
            ? controller.text
            : null,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          controller.text = value ?? '';
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(addBillFormProvider);
    final formNotifier = ref.read(addBillFormProvider.notifier);
    final selectedProduct = ref.watch(selectedProductProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formState.formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () async {
                          showQrScannerDialog(context, formNotifier,ref);
                        },
                      ),
                    ),
                    buildTextField(
                        'ID (Scanned or Auto-generated)', Icons.tag, formState.idController),
                    buildTextField(
                        'Customer Name', Icons.person, formState.customerNameController),
                    buildTextField(
                        'Mobile Number', Icons.phone, formState.mobileNumberController),
                    buildTextField('City', Icons.location_city, formState.cityController),
                    ProductMasterDropdown(),
                    const SizedBox(height: 10),
                    ProductDropdownWidget(),
                    buildDropdownField(
                      label: 'Color',
                      icon: Icons.color_lens,
                      options: colorOptions,
                      controller: formState.colorController,
                    ),
                    buildTextField('Amount', Icons.currency_rupee, formState.amountController),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: formState.isSubmitting
                            ? null
                            : () => formNotifier.submitData(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.teal,
                        ),
                        child: formState.isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showQrScannerDialog(BuildContext context, AddBillNotifier formNotifier, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Scan QR Code"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: mobileScanner(ctx, formNotifier,ref),
        ),
      );
    },
  );
}

Widget mobileScanner(BuildContext context, AddBillNotifier formNotifier, WidgetRef ref) {
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

                // Fill form fields directly
                formNotifier.setFieldValues(
                  id: productData['productId']?.toString() ?? '',
                  category:  productData['category']?.toString() ?? '',
                  itemName: productData['productName']?.toString() ?? '',
                  amount: productData['price']?.toString() ?? '',
                  qty: productData['qty']?.toString() ?? '',
                );
                ref.read(scannedCategoryProvider.notifier).state = productData['productCategory']?.toString() ?? '';
                ref.read(scannedProductProvider.notifier).state = productData['productName']?.toString() ?? '';
                Navigator.pop(context); // Close dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code scanned successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid QR code data')),
                );
              }
            }
          },
        ),
      ),
    ),
  );
}
