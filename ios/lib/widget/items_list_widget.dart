import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/bill_item_model.dart';

class ItemsListWidget extends StatelessWidget {
  final List<BillItemModel> items;
  final Function(int) onRemoveItem;
  final Function(int, BillItemModel) onUpdateItem;

  const ItemsListWidget({
    super.key,
    required this.items,
    required this.onRemoveItem,
    required this.onUpdateItem,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'no_items_added'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'items_list'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildItemCard(context, index, item);
            }).toList(),
            const Divider(),
            _buildTotalRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, int index, BillItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text('${index + 1}'),
        ),
        title: Text(item.productName),
        subtitle: Text('${item.category} • ${item.color}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.quantity}x ₹${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '₹${item.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemoveItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow() {
    final grandTotal = items.fold(0.0, (sum, item) => sum + item.totalAmount);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'grand_total'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '₹${grandTotal.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
      ],
    );
  }
}
