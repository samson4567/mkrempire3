import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkrempire/resources/screens/billpayments/bill_payments.dart';
import 'package:mkrempire/resources/screens/giftcard/giftcard_screen.dart';
import 'package:mkrempire/resources/screens/finance/history_screen.dart';
import 'package:mkrempire/resources/screens/home_screen.dart';
import 'package:mkrempire/resources/screens/others/more_screen.dart';
import 'package:mkrempire/resources/screens/virtual_card/virtual_card_screen.dart';

import '../../resources/screens/crypto/trade_screen.dart';
import '../../routes/route_names.dart';

class NavigationController extends GetxController {
  // Observable variable to track the current selected index
  int selectedIndex = 0;
  late final List<Widget> screens;

  // List of screens for each tab

  @override
  void onInit() {
    super.onInit();
    screens = [
      const HomeScreen(),
      // const WalletScreen(),
      const BillPayments(),
      const VirtualCardScreen(),
      const GiftcardScreen(),
      // const HistoryScreen(),
      // const TradeScreen(),
      const MoreScreen(),
    ];
  }

  Widget get currentScreen => screens[selectedIndex];

  void changeScreen(int index) {
    selectedIndex = index;
    update();
  }
}
