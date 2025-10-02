import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/billingList/billing_provider.dart';

class DateNavigator extends ConsumerWidget {
   final DateTime selectedDate;
  const DateNavigator({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).state =
                  selectedDate.subtract(const Duration(days: 1));
            },
          ),
          GestureDetector(
            onTap: (){
              pickDate(context, ref);
            },
            child:   Text(
              DateFormat('EEE, MMM d, yyyy').format(selectedDate),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).state =
                  selectedDate.add(const Duration(days: 1));
            },
          ),
        ],
      ),
    );
  }
}
