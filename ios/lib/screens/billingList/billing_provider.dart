import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/apiServices.dart';
import '../../model/billing_list_model.dart';


// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected date for filtering
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Provide service
final billServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider to fetch bills by date
final billsByDateProvider =
FutureProvider.family<List<BillingListModel>, String>((ref, date) async {
  final service = ref.watch(billServiceProvider);
  return service.getBillsByDate(date);
});

Future<void> pickDate(BuildContext context, WidgetRef ref) async {
  final currentDate = ref.read(selectedDateProvider);

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    ref.read(selectedDateProvider.notifier).state = pickedDate;
  }
}

/// Refresh billing data for current date
void refreshBillingData(WidgetRef ref) {
  final selectedDate = ref.read(selectedDateProvider);
  final dateString = DateFormat('dd-MM-yyyy').format(selectedDate);
  ref.invalidate(billsByDateProvider(dateString));
}