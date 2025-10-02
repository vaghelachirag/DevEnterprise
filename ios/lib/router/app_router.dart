// lib/router/app_router.dart

import 'package:go_router/go_router.dart';

import '../extensions/utils/app_constant.dart';
import '../screens/addBills/multiItemBillPage.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: AppConstant.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppConstant.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppConstant.multiItemBill,
      builder: (context, state) => const MultiItemBillPage(),
    ),
  ],
  redirect: (context, state) {
    if (state.fullPath == '/') {
      return '/dashboard/home';
    }
    return null;
  },
);
