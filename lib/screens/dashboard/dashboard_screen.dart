import 'package:deventerprise/screens/billingList/billing_screen.dart';
import 'package:easy_localization/easy_localization.dart';
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
    // Set initial language based on current locale
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Safe to use inherited widgets here
    final locale = context.locale; // Example with EasyLocalization
    print("Current locale: $locale");
    _updateSelectedLangFromLocale();
    // You can also initialize things that depend on localization, theme, mediaQuery, etc.
  }

  void _updateSelectedLangFromLocale() {
    final currentLocale = context.locale.languageCode;
    switch (currentLocale) {
      case 'en':
        _selectedLang = "English";
        break;
      case 'hi':
        _selectedLang = "Hindi";
        break;
      case 'gu':
        _selectedLang = "Gujarati";
        break;
      default:
        _selectedLang = "English";
    }
  }

  void _changeLanguage(String language) async {
    Locale newLocale;
    String languageCode;

    switch (language) {
      case "English":
        newLocale = const Locale('en');
        languageCode = 'en';
        break;
      case "Hindi":
        newLocale = const Locale('hi');
        languageCode = 'hi';
        break;
      case "Gujarati":
        newLocale = const Locale('gu');
        languageCode = 'gu';
        break;
      default:
        newLocale = const Locale('en');
        languageCode = 'en';
    }

    // Change the app locale
    await context.setLocale(newLocale);

    setState(() {
      _selectedLang = language;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Language changed to $language"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1CA8A8),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "billing".tr(),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language, color: Colors.white),
              onSelected: _changeLanguage,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "English",
                  child: Row(
                    children: [
                      Text("English"),
                      if (_selectedLang == "English")
                        const Icon(Icons.check, color: Colors.green, size: 20),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Hindi",
                  child: Row(
                    children: [
                      Text("हिंदी"),
                      if (_selectedLang == "Hindi")
                        const Icon(Icons.check, color: Colors.green, size: 20),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Gujarati",
                  child: Row(
                    children: [
                      Text("ગુજરાતી"),
                      if (_selectedLang == "Gujarati")
                        const Icon(Icons.check, color: Colors.green, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'add_bill'.tr()),
              Tab(text: 'billing_list'.tr()),
            ],
          ),
        ),
        body: TabBarView(children: [AddBillsPage(), BillingScreen()]),
      ),
    );
  }
}
