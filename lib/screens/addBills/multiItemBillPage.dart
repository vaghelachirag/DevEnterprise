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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddItemDialog(context, billNotifier),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('add_item'.tr()),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: billState.formKey,
            child: Column(
              children: [
                // Customer Information Card
                Card(
                  elevation: 6,
                  shadowColor: Colors.teal.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'customer_information'.tr(),
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: billState.customerNameController,
                          label: 'customer_name'.tr(),
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: billState.mobileNumberController,
                          label: 'mobileNumber'.tr(),
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: billState.cityController,
                          label: 'city'.tr(),
                          icon: Icons.location_city,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Items List
                ItemsListWidget(
                  items: billState.items,
                  onRemoveItem: billNotifier.removeItem,
                  onUpdateItem: billNotifier.updateItem,
                ),

                const SizedBox(height: 80), // space for bottom button
              ],
            ),
          ),
        ),

        // Bottom Submit Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: billState.isSubmitting
                  ? null
                  : () => billNotifier.submitBill(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                foregroundColor: Colors.white,
                elevation: 6,
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
        ),
      ),
    );
  }

  // 🔹 Reusable TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (val) => val == null || val.isEmpty ? 'required'.tr() : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
