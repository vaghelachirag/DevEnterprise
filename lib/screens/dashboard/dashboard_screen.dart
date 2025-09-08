import 'package:deventerprise/screens/billingList/billing_screen.dart';
import 'package:flutter/material.dart';

import '../addBills/addBillsPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const route = "/DashboardScreen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLang = "English"; // default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Billing"),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (value) {
                setState(() {
                  _selectedLang = value;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Language changed to $value")),
                );
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "English", child: Text("English")),
                const PopupMenuItem(value: "Hindi", child: Text("हिंदी")),
                const PopupMenuItem(value: "Gujarati", child: Text("ગુજરાતી")),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add Bill'),
              Tab(text: 'Billing List'),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            AddBillsPage(),
            BillingScreen(),
          ],
        ),
      ),
    );
  }
}
