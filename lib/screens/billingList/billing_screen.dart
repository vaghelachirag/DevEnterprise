import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/dateNavigator.dart';
import '../billDetail/bill_detail_screen.dart';
import 'billing_provider.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    final billsAsync = ref.watch(
      billsByDateProvider(DateFormat('dd-MM-yyyy').format(selectedDate)),
    );

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSearchBar(ref),
          ),
          const SizedBox(height: 8),
          DateNavigator(selectedDate: selectedDate),
          const SizedBox(height: 8),
          // ✅ Use AsyncValue.when to handle loading/error/data
          Expanded(
            child: billsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
              data: (bills) {
                // ✅ Filter bills using search query
                final filtered = bills.where((bill) {
                  return bill.customerName
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                      bill.mobileNumber.toString().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(child: Text('no_customers'.tr()));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final customer = filtered[index];
                    return GestureDetector(
                      onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BillDetailScreen(
                              billNo: customer.id.toString(),
                              customerName: customer.customerName,
                              mobileNumber: customer.mobileNumber.toString(),
                              address: customer.city,
                              billDate: customer.date,
                              productName: customer.productName,
                              category: customer.category,
                             price: customer.sellingPrice.toString(),
                                  qty: customer.qty.toString(), totalAmount: customer.totalAmount.toString(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                child: Icon(Icons.person, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.customerName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.mobileNumber.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.date_range,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text(
                                          // ✅ If customer.date is String, parse safely
                                          customer.date.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.attach_money,
                                            size: 16, color: Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.totalAmount
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.redAccent),
                                onPressed: () {

                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'search_customer_hint'.tr(),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (val) =>
      ref.read(searchQueryProvider.notifier).state = val,
    );
  }
}
