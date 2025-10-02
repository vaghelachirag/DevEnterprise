import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/bill_item_model.dart';
import '../../../model/multi_item_bill_model.dart';
import '../../billingList/billing_provider.dart';
import '../provider/category_provider.dart';

class MultiItemBillProvider {
  final TextEditingController customerNameController;
  final TextEditingController mobileNumberController;
  final TextEditingController cityController;
  final List<BillItemModel> items;
  final bool isSubmitting;
  final bool? submitSuccess;
  final GlobalKey<FormState> formKey;

  MultiItemBillProvider({
    required this.customerNameController,
    required this.mobileNumberController,
    required this.cityController,
    required this.items,
    required this.formKey,
    this.isSubmitting = false,
    this.submitSuccess,
  });

  MultiItemBillProvider copyWith({
    List<BillItemModel>? items,
    bool? isSubmitting,
    bool? submitSuccess,
  }) {
    return MultiItemBillProvider(
      customerNameController: customerNameController,
      mobileNumberController: mobileNumberController,
      cityController: cityController,
      items: items ?? this.items,
      formKey: formKey,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }

  double get grandTotal {
    return items.fold(0.0, (sum, item) => sum + item.totalAmount);
  }
}

class MultiItemBillNotifier extends StateNotifier<MultiItemBillProvider> {
  final Ref ref;

  MultiItemBillNotifier(this.ref)
    : super(
        MultiItemBillProvider(
          customerNameController: TextEditingController(),
          mobileNumberController: TextEditingController(),
          cityController: TextEditingController(),
          items: [],
          formKey: GlobalKey<FormState>(),
        ),
      );

  @override
  void dispose() {
    state.customerNameController.dispose();
    state.mobileNumberController.dispose();
    state.cityController.dispose();
    super.dispose();
  }

  void addItem(BillItemModel item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void removeItem(int index) {
    final newItems = List<BillItemModel>.from(state.items);
    newItems.removeAt(index);
    state = state.copyWith(items: newItems);
  }

  void updateItem(int index, BillItemModel updatedItem) {
    final newItems = List<BillItemModel>.from(state.items);
    newItems[index] = updatedItem;
    state = state.copyWith(items: newItems);
  }

  void clearAllItems() {
    state = state.copyWith(items: []);
  }

  Future<void> submitBill(BuildContext context) async {
    if (!state.formKey.currentState!.validate()) return;
    if (state.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_add_at_least_one_item'.tr())),
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, submitSuccess: null);

    try {
      final apiService = ref.read(apiServiceProvider);

      String todayDate = DateFormat(
        'MM-dd-yyyy',
      ).format(DateTime.now()).toString();

      final bill = MultiItemBillModel(
        billId: DateTime.now().millisecondsSinceEpoch.toString(),
        action: "addBill", // same action name for backend
        billDate: todayDate,
        customerName: state.customerNameController.text.trim(),
        mobileNumber: state.mobileNumberController.text.trim(),
        city: state.cityController.text.trim(),
        items: state.items,
        grandTotal: state.grandTotal,
      );

      // Submit ALL items in ONE API call
      await apiService.submitMultiItemBill(bill);

      // Reduce quantity for all items in ONE API call if supported
      for (final item in state.items) {
        await apiService.reduceQty(
          productId: item.productId,
          reduceBy: item.quantity,
        );
      }

      // Refresh billing list
      ref.invalidate(billsByDateProvider);
      // Stop progress and mark success before showing dialog
      state = state.copyWith(isSubmitting: false, submitSuccess: true);
      _showSuccessDialog(context);
      _resetForm();
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitSuccess: false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${"failed".tr()}: $e")));
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('success'.tr()),
        content: Text('bill_submitted_successfully'.tr()),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    state.customerNameController.clear();
    state.mobileNumberController.clear();
    state.cityController.clear();
    clearAllItems();
  }
}

final multiItemBillProvider =
    StateNotifierProvider<MultiItemBillNotifier, MultiItemBillProvider>(
      (ref) => MultiItemBillNotifier(ref),
    );
