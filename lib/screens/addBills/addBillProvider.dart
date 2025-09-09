import 'package:deventerprise/model/add_bill_model.dart';
import 'package:deventerprise/screens/addBills/provider/category_provider.dart';
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
      );

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
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final bill = AddBillModel(
        id: state.idController.text.trim(),
        action: "addBill",
        date: todayDate,
        customerName: state.customerNameController.text.trim(),
        mobileNumber: state.mobileNumberController.text.trim(),
        city: state.cityController.text.trim(),
        category: selectedCategory?.toString() ?? "",
        productName: selectedProduct?.toString() ?? "",
        purchasePrice: price.toStringAsFixed(2).toString(),
        sellingPrice: price.toStringAsFixed(2).toString(),
        quantity: qty.toString(),
        totalAmount: totalAmount.toStringAsFixed(2).toString(),
      );

      final result = await apiService.submitData(bill);

      if (result) {
        try {
          // Get the product ID from the selected product or form
          String productId = state.idController.text
              .trim(); // or get from selectedProduct

          await apiService.reduceQty(productId: productId, reduceBy: qty);

          print('Product quantity reduced successfully');
        } catch (reduceQtyError) {
          print('Failed to reduce product quantity: $reduceQtyError');
          // You might want to show a warning to the user here
        }

        state.customerNameController.clear();
        state.mobileNumberController.clear();
        state.cityController.clear();
        state.amountController.clear();
        state.idController.clear();
        state.qtyController.clear();

        ref.read(selectedProductProvider.notifier).state = null;

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("success".tr()),
            content: Text("bill_submitted_successfully".tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("ok".tr()),
              ),
            ],
          ),
        );
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
