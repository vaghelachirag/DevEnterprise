import 'package:deventerprise/screens/addBills/addBillsPage.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const route = "/DashboardScreen";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mobile Billing App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Add Bill'),
              Tab(text: 'Billing List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddBillsPage(), // your form
            AddBillsPage() // placeholder
          ],
        ),
      ),
    );
  }
}
