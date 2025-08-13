import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/addBills/addBillProvider.dart';

Widget CategoryDropdownWidget({
  required WidgetRef ref,
  required String label,
  required IconData icon,
  required List<String> options,
}) {
  final selectedValue = ref.watch(dropdownValueProvider);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: options.contains(selectedValue) ? selectedValue : null,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        ref.read(dropdownValueProvider.notifier).state = value;
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
      validator: (value) =>
      value == null || value.isEmpty ? 'Required' : null,
    ),
  );
}
