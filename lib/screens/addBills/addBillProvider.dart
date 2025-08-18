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
    required this.categoryController,
    required this.hsnController,
    required this.amountController,
    required this.formKey,
    this.isSubmitting = false,
    this.submitSuccess,
  });

  AddBillProvider copyWith({
    bool? isSubmitting,
    bool? submitSuccess,
  }) {
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
  Future<void> submitData() async {
    if (!state.formKey.currentState!.validate()) return;
    state = state.copyWith(isSubmitting: true, submitSuccess: null);

    final selectedProduct = ref.watch(selectedProductProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);


    double price = double.tryParse(state.amountController.text) ?? 0;
    int qty = int.tryParse("1") ?? 0;
    double totalAmount = price * qty;

    try {
      final apiService = ref.read(apiServiceProvider);
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final data = {
        "action": "addBill",
        "Id": state.idController.text,
        "Date": todayDate,
        "CustomerName": state.customerNameController.text,
        "MobileNumber": state.mobileNumberController.text,
        "City": state.cityController.text,
        "Category": selectedProduct.toString(),
        "ProductName": selectedCategory.toString(),
        "PurchasePrice": "200",
        "SellingPrice": state.amountController.text,
        "Qty": "1"
      };

      final result = await apiService.submitData(data);

      state = state.copyWith(isSubmitting: false, submitSuccess: result);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitSuccess: false);
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
