import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final GlobalKey<FormState> formKey;

  void setFieldValues({
    String? id,
    String? itemName,
    String? amount,
    String? qty,
  }) {
    if (id != null) idController.text = id;
    if (itemName != null) itemNameController.text = itemName;
    if (amount != null) amountController.text = amount;
    // If you have qtyController
    // if (qty != null) qtyController.text = qty;
  }

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
  });

  AddBillProvider copyWith({bool? isSubmitting}) {
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
    );
  }
}

class AddBillNotifier extends StateNotifier<AddBillProvider> {
  AddBillNotifier() : super(
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
    // If you add a qtyController later, set it here
    // if (qty != null) state.qtyController.text = qty;
  }


  Future<void> submitData() async {
    if (!state.formKey.currentState!.validate()) return;

    state = state.copyWith(isSubmitting: true);

    try {
      // TODO: Replace with your API or Google Sheet call
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}


final addBillFormProvider =
StateNotifierProvider<AddBillNotifier, AddBillProvider>(
        (ref) => AddBillNotifier());

final dropdownValueProvider = StateProvider<String?>((ref) => null);