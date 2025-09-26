import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/item_entry_widget.dart';
import '../../widget/items_list_widget.dart';
import 'provider/multi_item_bill_provider.dart';

class MultiItemBillPage extends ConsumerWidget {
  const MultiItemBillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billState = ref.watch(multiItemBillProvider);
    final billNotifier = ref.read(multiItemBillProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (billState.items.isNotEmpty) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('confirm_exit'.tr()),
              content: Text('exit_confirmation_message'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text('yes'.tr()),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: billState.formKey,
              child: Column(
                children: [
                  // Customer Information Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'customer_information'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: billState.customerNameController,
                            decoration: InputDecoration(
                              labelText: 'customer_name'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'required'.tr()
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: billState.mobileNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'mobileNumber'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'required'.tr()
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: billState.cityController,
                            decoration: InputDecoration(
                              labelText: 'city'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'required'.tr()
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Items List
                  ItemsListWidget(
                    items: billState.items,
                    onRemoveItem: billNotifier.removeItem,
                    onUpdateItem: billNotifier.updateItem,
                  ),
                  const SizedBox(height: 16),
                  // Add Item Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showAddItemDialog(context, billNotifier),
                      icon: const Icon(Icons.add),
                      label: Text('add_item'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: billState.isSubmitting
                          ? null
                          : () => billNotifier.submitBill(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: billState.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'submit_bill'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    MultiItemBillNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: ItemEntryWidget(
            onAddItem: (item) {
              notifier.addItem(item);
              Navigator.of(ctx).pop();
            },
            onCancel: () => Navigator.of(ctx).pop(),
          ),
        ),
      ),
    );
  }
}
