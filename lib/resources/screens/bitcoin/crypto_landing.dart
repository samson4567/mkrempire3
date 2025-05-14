import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../routes/route_names.dart';

class CryptoActionsScreen extends StatefulWidget {
  const CryptoActionsScreen({super.key});

  @override
  State<CryptoActionsScreen> createState() => _CryptoActionsScreenState();
}

class _CryptoActionsScreenState extends State<CryptoActionsScreen> {
  final List<Map<String, dynamic>> cryptoActions = [
    {
      'title': 'Buy & Sell',
      'svg': 'buy_sell', // should be in assets/svgs/buy_sell.svg
      'color': Colors.green,
      // 'ontap': () => Get.toNamed(RoutesName.tradingScreen),
    },
    {
      'title': 'Swap Crypto',
      'svg': 'swap',
      'color': Colors.orange,
      'ontap': () => Get.toNamed(RoutesName.cryptoSwap),
    },
    {
      'title': 'History',
      'svg': 'history',
      'color': Colors.blue,
      'ontap': () => Get.toNamed(RoutesName.cryptoHistory),
    },
    {
      'title': 'Deposit/Withdraw',
      'svg': 'wallet',
      'color': Colors.purple,
      'ontap': () => Get.toNamed(RoutesName.cryptoDepositWithdraw),
    },
  ];

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Actions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Crypto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 1, // just 1 page for now
                itemBuilder: (context, pageIndex) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: cryptoActions.length,
                    itemBuilder: (context, index) {
                      final item = cryptoActions[index];
                      return GestureDetector(
                        onTap: item['ontap'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: item['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/${item['svg']}.svg',
                                height: 40,
                                width: 40,
                                color: item['color'],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: item['color'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 1,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
