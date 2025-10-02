import 'package:deventerprise/model/add_bill_model.dart';
import 'package:deventerprise/screens/addBills/provider/category_provider.dart';
import 'package:deventerprise/screens/billingList/billing_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider state (form controllers + flags)
class AddBillProvider {
  final TextEditingController idController;
  final TextEditingController customerNameController;
  final TextEditingController mobileNumberController;
  final TextEditingController cityController;
  final TextEditingController itemNameController;
  final TextEditingController colorController;
  final TextEditingController qtyController;
  final TextEditingController categoryController;
  final TextEditingController hsnController;
  final TextEditingController amountController;
  final bool isSubmitting;
  final bool? submitSuccess; // ✅ NEW: null = not submitted, true/false = result
  final GlobalKey<FormState> formKey;

  AddBillProvider({
    required this.idController,
    required this.customerNameController,
    required this.mobileNumberController,
    required this.cityController,
    required this.itemNameController,
    required this.colorController,
    required this.qtyController,
    required this.categoryController,
    required this.hsnController,
    required this.amountController,
    required this.formKey,
    this.isSubmitting = false,
    this.submitSuccess,
  });

  AddBillProvider copyWith({bool? isSubmitting, bool? submitSuccess}) {
    return AddBillProvider(
      idController: idController,
      customerNameController: customerNameController,
      mobileNumberController: mobileNumberController,
      cityController: cityController,
      itemNameController: itemNameController,
      colorController: colorController,
      categoryController: categoryController,
      hsnController: hsnController,
      amountController: amountController,
      qtyController: qtyController,
      formKey: formKey,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }
}

// Notifier
class AddBillNotifier extends StateNotifier<AddBillProvider> {
  final Ref ref;

  AddBillNotifier(this.ref)
    : super(
        AddBillProvider(
          idController: TextEditingController(
            text: DateTime.now().millisecondsSinceEpoch.toString(),
          ),
          customerNameController: TextEditingController(),
          mobileNumberController: TextEditingController(),
          cityController: TextEditingController(),
          itemNameController: TextEditingController(),
          colorController: TextEditingController(),
          categoryController: TextEditingController(),
          hsnController: TextEditingController(),
          amountController: TextEditingController(),
          formKey: GlobalKey<FormState>(),
          qtyController: TextEditingController(),
        ),
      ) {
    // Sync selected product ID -> product NAME into itemNameController
    ref.listen<String?>(selectedProductProvider, (previous, next) {
      if (next == null || next.isEmpty) {
        state.itemNameController.text = '';
        return;
      }

      final productsAsync = ref.read(productsByCategoryProvider);
      final name = productsAsync.maybeWhen(
        data: (list) {
          try {
            return list.firstWhere((p) => p.id == next).productName.trim();
          } catch (_) {
            return null;
          }
        },
        orElse: () => null,
      );

      state.itemNameController.text = name ?? '';
    });
  }

  @override
  void dispose() {
    // Dispose all TextEditingControllers to prevent memory leaks
    state.idController.dispose();
    state.customerNameController.dispose();
    state.mobileNumberController.dispose();
    state.cityController.dispose();
    state.itemNameController.dispose();
    state.colorController.dispose();
    state.categoryController.dispose();
    state.hsnController.dispose();
    state.amountController.dispose();
    state.qtyController.dispose();
    super.dispose();
  }

  /// ✅ Fill form values from QR code data
  void setFieldValues({
    String? id,
    String? itemName,
    String? category,
    String? amount,
    String? qty,
  }) {
    if (id != null) state.idController.text = id;
    if (itemName != null) state.itemNameController.text = itemName;
    if (category != null) state.categoryController.text = category;
    if (amount != null) state.amountController.text = amount;
    if (itemName != null) state.itemNameController.text = itemName;
    // If you add a qtyController later, set it here
    // if (qty != null) state.qtyController.text = qty;
  }

  /// ✅ Show beautiful success dialog
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade50, Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon with Animation
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.teal.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Success Title
              Text(
                "success".tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 12),

              // Success Message
              Text(
                "bill_submitted_successfully".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade300),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          // Reset form for new bill
                          _resetForm();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal.shade600,
                        ),
                        child: Text(
                          "add_another".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade600, Colors.teal.shade700],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context); // Go back to previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "done".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  /// ✅ Reset form for new bill entry
  void _resetForm() {
    state.customerNameController.clear();
    state.mobileNumberController.clear();
    state.cityController.clear();
    state.amountController.clear();
    state.idController.text = DateTime.now().millisecondsSinceEpoch.toString();
    state.qtyController.clear();
    state.colorController.clear();
    state.itemNameController.clear();
    state.categoryController.clear();
    ref.read(selectedProductProvider.notifier).state = null;
    ref.read(selectedCategoryProvider.notifier).state = null;
  }

  /// ✅ Submit form
  Future<void> submitData(BuildContext context) async {
    if (!state.formKey.currentState!.validate()) return;
    state = state.copyWith(isSubmitting: true, submitSuccess: null);

    final selectedProduct = ref.watch(selectedProductProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    // safely parse values
    double price = double.tryParse(state.amountController.text) ?? 0;
    int qty =
        int.tryParse(state.qtyController.text) ??
        1; // parse quantity from controller
    double totalAmount = price * qty;

    try {
      final apiService = ref.read(apiServiceProvider);
      String todayDate = DateFormat(
        'MM-dd-yyyy',
      ).format(DateTime.now()).toString();
      print("📅 Saving bill with date: $todayDate");

      final bill = AddBillModel(
        // Align single-item flow with multi-item: use productId as Id
        id: (selectedProduct ?? state.idController.text).trim(),
        action: "addBill",
        billDate: todayDate.toString(),
        customerName: state.customerNameController.text.trim(),
        mobileNumber: state.mobileNumberController.text.trim(),
        city: state.cityController.text.trim(),
        category: selectedCategory?.toString() ?? "",
        productName: state.itemNameController.text.trim(),
        purchasePrice: price.toStringAsFixed(2).toString(),
        sellingPrice: price.toStringAsFixed(2).toString(),
        quantity: qty.toString(),
        totalAmount: totalAmount.toStringAsFixed(2).toString(),
      );

      final result = await apiService.submitData(bill);

      if (result) {
        try {
          // Use selected product ID for stock reduction (fallback to form Id)
          String productId = (selectedProduct ?? state.idController.text).trim();

          await apiService.reduceQty(productId: productId, reduceBy: qty);

          print('Product quantity reduced successfully');
        } catch (reduceQtyError) {
          print('Failed to reduce product quantity: $reduceQtyError');
          // You might want to show a warning to the user here
        }

        // Refresh billing list providers to show updated data
        ref.invalidate(billsByDateProvider);

        _showSuccessDialog(context);
      }
      state = state.copyWith(isSubmitting: false, submitSuccess: result);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitSuccess: false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${"failed".tr()}: $e")));
    }
  }
}

/// Form provider
final addBillFormProvider =
    StateNotifierProvider<AddBillNotifier, AddBillProvider>(
      (ref) => AddBillNotifier(ref),
    );

/// Dropdown value provider
final dropdownValueProvider = StateProvider<String?>((ref) => null);
