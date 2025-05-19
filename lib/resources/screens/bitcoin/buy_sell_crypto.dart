import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/routes/route_names.dart';

import '../../../config/app_colors.dart';

class BuyCryptoScreen extends StatefulWidget {
  const BuyCryptoScreen({super.key});

  @override
  State<BuyCryptoScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends State<BuyCryptoScreen> {
  final TextEditingController _amountController = TextEditingController();
  String selectedCrypto = 'BTC';
  double currentPrice = 43250.75;

  // Get theme colors based on current mode
  Color get primaryColor =>
      Get.isDarkMode ? AppColors.mainColor : AppColors.mainColor;
  Color get secondaryColor => AppColors.mainColor;
  Color get textColor => Get.isDarkMode ? Colors.white : Colors.black;
  Color get subtextColor => Get.isDarkMode ? Colors.white70 : Colors.black87;
  Color get backgroundColor => Get.isDarkMode ? Colors.black : Colors.white;
  Color get surfaceColor =>
      Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Buy Crypto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(RoutesName.sellScreen);
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => const SellCryptoScreen(),
              //   ),
              // );
            },
            child: const Text(
              'Sell',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBalanceHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildBuyView(),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      color: primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            'Available Naira Balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '0.00 NGN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyView() {
    final controller = Get.find<CryptoController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From Currency Selection
          _buildCurrencySelection(
            icon: Icon(Icons.currency_exchange,
                color: Get.isDarkMode ? Colors.white : Colors.black),
            label: 'Nigerian Naira',
            isSelectable: false,
          ),
          const SizedBox(height: 16),

          // To Currency Selection (Bitcoin)
          Obx(() {
            return _buildCurrencySelection(
              icon:
                  Image.asset('assets/images/25503.jpg', width: 24, height: 24),
              label: 'BTC',
              isSelectable: true,
              onTap: () {
                // Show cryptocurrency selection dialog
              },
            );
          }),
          const SizedBox(height: 16),

          // Amount Input Field
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: primaryColor),
                    ),
                  ),
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    style: TextStyle(color: textColor, fontSize: 18),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      hintStyle: TextStyle(color: subtextColor),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coin Amount Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Coin Amount',
                style: TextStyle(
                  color: subtextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Conversion Rate Display
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/25503.jpg',
                        width: 32, height: 32),
                    const SizedBox(width: 8),
                    Text(
                      '\$1 = NGN 0',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '≈ 0 BTC',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                // Implement buy logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelection({
    required Widget icon,
    required String label,
    bool isSelectable = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: icon,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelectable)
              Icon(
                Icons.keyboard_arrow_down,
                color: textColor,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class SellCryptoScreen extends StatefulWidget {
  const SellCryptoScreen({super.key});

  @override
  State<SellCryptoScreen> createState() => _SellCryptoScreenState();
}

class _SellCryptoScreenState extends State<SellCryptoScreen> {
  final TextEditingController _amountController = TextEditingController();
  String selectedCrypto = 'BTC';
  double currentPrice = 43250.75;

  // Get theme colors based on current mode
  Color get primaryColor => AppColors.mainColor;
  Color get secondaryColor => AppColors.mainColor;
  Color get textColor => Get.isDarkMode ? Colors.white : Colors.black;
  Color get subtextColor => Get.isDarkMode ? Colors.white70 : Colors.black87;
  Color get backgroundColor => Get.isDarkMode ? Colors.black : Colors.white;
  Color get surfaceColor =>
      Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sell Crypto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(RoutesName.buyScreen);
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => const BuyCryptoScreen(),
              //   ),
              // );
            },
            child: const Text(
              'Buy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBalanceHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildSellView(),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      color: primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            'Available Crypto Balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '0.00 BTC',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellView() {
    final controller = Get.find<CryptoController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From Currency Selection (Crypto)
          Obx(() {
            return _buildCurrencySelection(
              icon:
                  Image.asset('assets/images/25503.jpg', width: 24, height: 24),
              label: 'btc',
              isSelectable: true,
              onTap: () {
                // Show cryptocurrency selection dialog
              },
            );
          }),
          const SizedBox(height: 16),

          // To Currency Selection (Naira)
          _buildCurrencySelection(
            icon: Icon(Icons.currency_exchange,
                color: Get.isDarkMode ? Colors.white : Colors.black),
            label: 'Nigerian Naira',
            isSelectable: false,
          ),
          const SizedBox(height: 16),

          // Amount Input Field
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: primaryColor),
                    ),
                  ),
                  child: Text(
                    'BTC',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    style: TextStyle(color: textColor, fontSize: 18),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      hintStyle: TextStyle(color: subtextColor),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Naira Amount Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Naira Amount',
                style: TextStyle(
                  color: subtextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Conversion Rate Display
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/25503.jpg',
                        width: 32, height: 32),
                    const SizedBox(width: 8),
                    Text(
                      '1 BTC = NGN 0',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '≈ 0 NGN',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                // Implement sell logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelection({
    required Widget icon,
    required String label,
    bool isSelectable = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: icon,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelectable)
              Icon(
                Icons.keyboard_arrow_down,
                color: textColor,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

// class BuySellCryptoScreen extends StatefulWidget {
//   const BuySellCryptoScreen({super.key});

//   @override
//   State<BuySellCryptoScreen> createState() => _BuySellCryptoScreenState();
// }

// class _BuySellCryptoScreenState extends State<BuySellCryptoScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _amountController = TextEditingController();
//   String selectedCrypto = 'BTC';
//   double currentPrice = 43250.75;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {}); // Refresh UI when tab changes
//     });
//   }

//   // Get theme colors based on current mode
//   Color get primaryColor => Get.isDarkMode ? Colors.blue : Colors.indigo;
//   Color get secondaryColor =>
//       Get.isDarkMode ? Colors.blue.shade700 : Colors.indigo.shade300;
//   Color get textColor => Get.isDarkMode ? Colors.white : Colors.black;
//   Color get subtextColor => Get.isDarkMode ? Colors.white70 : Colors.black87;
//   Color get backgroundColor => Get.isDarkMode ? Colors.black : Colors.white;
//   Color get surfaceColor =>
//       Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Trade',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: primaryColor,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Column(
//               children: [
//                 const Text(
//                   'Available Naira Balance',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   '0.00 NGN',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 28,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: primaryColor, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _tabController.animateTo(0);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _tabController.index == 0
//                           ? surfaceColor
//                           : Colors.transparent,
//                       foregroundColor:
//                           _tabController.index == 0 ? primaryColor : textColor,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(
//                       'Buy',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _tabController.index == 0
//                             ? primaryColor
//                             : textColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _tabController.animateTo(1);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _tabController.index == 1
//                           ? surfaceColor
//                           : Colors.transparent,
//                       foregroundColor:
//                           _tabController.index == 1 ? primaryColor : textColor,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(
//                       'Sell',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _tabController.index == 1
//                             ? primaryColor
//                             : textColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildBuyView(),
//                 _buildSellView(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBuyView() {
//     final controller = Get.find<CryptoController>();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // From Currency Selection
//           _buildCurrencySelection(
//             icon: Icon(Icons.currency_exchange,
//                 color: Get.isDarkMode ? Colors.white : Colors.black),
//             label: 'Nigerian Naira',
//             isSelectable: false,
//           ),
//           const SizedBox(height: 16),

//           // To Currency Selection (Bitcoin)
//           Obx(() {
//             return _buildCurrencySelection(
//               icon: Image.asset('assets/images/bitcoin.png',
//                   width: 24, height: 24),
//               label: controller.selectedCrypto.value,
//               isSelectable: true,
//               onTap: () {
//                 // Show cryptocurrency selection dialog
//               },
//             );
//           }),
//           const SizedBox(height: 16),

//           // Amount Input Field
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: primaryColor),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border(
//                       right: BorderSide(color: primaryColor),
//                     ),
//                   ),
//                   child: Text(
//                     '\$',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _amountController,
//                     style: TextStyle(color: textColor, fontSize: 18),
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Amount',
//                       hintStyle: TextStyle(color: subtextColor),
//                       contentPadding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Coin Amount Display
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: primaryColor),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Center(
//               child: Text(
//                 'Coin Amount',
//                 style: TextStyle(
//                   color: subtextColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Conversion Rate Display
//           Center(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/images/bitcoin.png',
//                         width: 32, height: 32),
//                     const SizedBox(width: 8),
//                     Text(
//                       '\$1 = NGN 0',
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '≈ 0 BTC',
//                   style: TextStyle(
//                     color: primaryColor,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const Spacer(),

//           // Continue Button
//           Container(
//             width: double.infinity,
//             margin: const EdgeInsets.only(bottom: 20),
//             child: ElevatedButton(
//               onPressed: () {
//                 // Implement buy logic
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Continue',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSellView() {
//     // Implement sell view with similar structure to buy view
//     return _buildBuyView(); // Replace with actual sell view implementation
//   }

//   Widget _buildCurrencySelection({
//     required Widget icon,
//     required String label,
//     bool isSelectable = false,
//     Function()? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: primaryColor),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: primaryColor,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: icon,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const Spacer(),
//             if (isSelectable)
//               Icon(
//                 Icons.keyboard_arrow_down,
//                 color: textColor,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
// }
// class _BuySellCryptoScreenState extends State<BuySellCryptoScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _amountController = TextEditingController();
//   String selectedCrypto = 'BTC';
//   double currentPrice = 43250.75; // Example price

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Buy/Sell Crypto',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Theme.of(context).primaryColor,
//             child: TabBar(
//               controller: _tabController,
//               tabs: const [
//                 Tab(text: 'Buy'),
//                 Tab(text: 'Sell'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildTradeView(isBuy: true),
//                 _buildTradeView(isBuy: false),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTradeView({required bool isBuy}) {
//     final controller = Get.find<CryptoController>();
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Current Price',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Obx(() {
//                     final selectedItem = controller.cryptoList.firstWhere(
//                       (item) => item.symbol == controller.selectedCrypto.value,
//                       orElse: () => controller.cryptoList.first,
//                     );
//                     // Extract and format the price
//                     String price =
//                         selectedItem.quote?.usd?.price?.toStringAsFixed(2) ??
//                             '\$0.00';
//                     // Remove the $ symbol and convert to double if you need numeric formatting
//                     double currentPrice =
//                         double.tryParse(price.replaceAll('\$', '')) ?? 0.0;

//                     return Text(
//                       '\$${currentPrice.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           TextField(
//             controller: _amountController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'Amount in USD',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.attach_money),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(() {
//             // Show loading indicator
//             if (controller.isLoading.value) {
//               return const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }

//             // Combined list of items (mock data if real data is empty)
//             List<Map<String, dynamic>> dropdownItems = [];

//             // If real data is empty, use mock data
//             if (controller.cryptoList.isEmpty) {
//               dropdownItems = [
//                 {
//                   'symbol': 'BTC',
//                   'price': '\$82,757.00',
//                   'change': '-0.02%',
//                   'color': Colors.amber,
//                   'iconData': null,
//                   'isNegative': true,
//                 },
//                 {
//                   'symbol': 'ETH',
//                   'price': '\$1,788.91',
//                   'change': '-0.03%',
//                   'color': Colors.blueGrey,
//                   'iconData': Icons.currency_exchange,
//                   'isNegative': true,
//                 },
//               ];
//             } else {
//               // Use real data
//               dropdownItems = controller.cryptoList.map((item) {
//                 final price = item.quote?.usd?.price != null
//                     ? '\$${item.quote!.usd!.price!.toStringAsFixed(2)}'
//                     : "\$0.00";

//                 final percentChange = item.quote?.usd?.percentChange24h;
//                 final change = percentChange != null
//                     ? '${percentChange.toStringAsFixed(2)}%'
//                     : "0.00%";

//                 final isNegative = (percentChange ?? 0) < 0;

//                 final colors = {
//                   'BTC': Colors.amber,
//                   'ETH': Colors.blueGrey,
//                   'XRP': Colors.black,
//                   'SOL': Colors.purple,
//                   'USDT': Colors.green,
//                   'USDC': Colors.blue,
//                   'TRX': Colors.red,
//                 };

//                 final icons = {
//                   'BTC': null,
//                   'ETH': Icons.currency_exchange,
//                   'XRP': Icons.currency_exchange,
//                   'SOL': Icons.currency_exchange,
//                   'USDT': Icons.monetization_on,
//                   'USDC': Icons.attach_money,
//                   'TRX': Icons.trending_down,
//                 };

//                 final symbol = item.symbol ?? "UNKNOWN";

//                 return {
//                   'symbol': symbol,
//                   'price': price,
//                   'change': change,
//                   'color': colors[symbol] ?? Colors.grey,
//                   'iconData': icons[symbol],
//                   'isNegative': isNegative,
//                 };
//               }).toList();
//             }

//             // Add a value to track the selected item
//             dropdownItems = dropdownItems.toSet().toList();

//             // Validate and set selectedCrypto
//             String currentValue = controller.selectedCrypto.value;
//             bool isValidValue =
//                 dropdownItems.any((item) => item['symbol'] == currentValue);

//             if (!isValidValue && dropdownItems.isNotEmpty) {
//               controller.selectedCrypto.value =
//                   dropdownItems.first['symbol'] as String;
//               currentValue = controller.selectedCrypto.value;
//             }

//             if (dropdownItems.isEmpty) {
//               return const Text('No cryptocurrencies available');
//             }

//             return DropdownButton<String>(
//               value: currentValue,
//               isExpanded: true,
//               items: dropdownItems.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item['symbol'],
//                   child: Row(
//                     children: [
//                       if (item['iconData'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Icon(
//                             item['iconData'],
//                             color: item['color'],
//                           ),
//                         ),
//                       Text(
//                         item['symbol'],
//                         style: TextStyle(color: item['color']),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         item['price'],
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         item['change'],
//                         style: TextStyle(
//                           color: item['isNegative'] ? Colors.red : Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 if (newValue != null) {
//                   controller.selectedCrypto.value = newValue;
//                 }
//               },
//               hint: const Text('Select a cryptocurrency'),
//             );
//           }),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Implement buy/sell logic
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isBuy ? Colors.green : Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 isBuy ? 'Buy Now' : 'Sell Now',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Transaction Summary',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildSummaryRow('Transaction Fee', '\$2.99'),
//                   _buildSummaryRow('Processing Time', '~10 minutes'),
//                   _buildSummaryRow('Payment Method', 'Bank Transfer'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
// }
