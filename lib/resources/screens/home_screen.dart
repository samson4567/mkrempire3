import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/bitcoin/buy_sell_crypto.dart';
import 'package:mkrempire/resources/screens/crypto/crypto_deposit.dart';
import 'package:mkrempire/resources/screens/crypto/receive_crypto.dart';
import 'package:mkrempire/resources/screens/crypto/send_crypto.dart';
import 'package:mkrempire/resources/screens/crypto/swap_screen.dart';
import 'package:mkrempire/resources/screens/crypto/trade_screen.dart';
import 'package:mkrempire/resources/screens/crypto/withdraw.dart';
import 'package:mkrempire/resources/screens/others/more_screen.dart';
import 'package:mkrempire/resources/screens/virtual_card/virtual_card_screen.dart';
import 'package:mkrempire/resources/widgets/custom_advert_sliders.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_balance_card.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

import '../../app/controllers/profile_controller.dart';
import 'crypto/buy_crypto.dart';
import 'crypto/sell_crypto.dart';
import 'finance/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Map<String, dynamic>> firstDashboardShortCutData;
  final CryptoController cryptoController = Get.find<CryptoController>();
  @override
  void initState() {
    super.initState();
    load();
    cryptoController.getAllowedDepositCoins();
    // Initialize the list in initState to have access to context
    firstDashboardShortCutData = [
      {
        'title': 'Deposit',
        'svg': 'deposit',
        'color': const Color(0xFFFF00FF),
        'ontap': () {
          Get.toNamed(RoutesName.depositScreen);
        },
      },
      // {
      //   'title': 'Swap',
      //   'svg': 'swap',
      //   'color': const Color(0xff0089F0),
      //   'ontap': () {
      //     Get.to(()=> SwapScreen());
      //   },
      // },
      {
        'title': 'Withdraw',
        'svg': 'send',
        'color': const Color(0xffF45521),
        'ontap': () {
          Get.toNamed(RoutesName.transferToOtherBank);
        },
      },
      {
        // 'title': 'Giftcard',
        'title': 'Trade',
        'svg': 'buy',
        'color': const Color(0xffFF8900),
        'ontap': () {
          Get.to(() => TradeScreen()); // Create this route
        },
      },
      // {
      //   'title': 'Sell',
      //   'svg': 'transfer', // Add corresponding SVG asset
      //   'color': const Color(0xFFF34F7F), // Green color for emphasis
      //   'ontap': () {
      //     Get.to(()=>SendCrypto()); // Create this route
      //   },
      // },
      {
        'title': 'History',
        'svg': 'transaction',
        'color': const Color(0xffF45521),
        'ontap': () {
          Get.to(() => const HistoryScreen());
        },
      },
      {
        'title': 'Deposit Crypto',
        'svg': 'receive', // Add corresponding SVG asset
        'color': const Color(0xFF4C1150), // Green color for emphasis
        'ontap': () {
          Get.to(() => CryptoDeposit());
        },
      },
      {
        'title': 'Withdraw Crypto',
        'svg': 'sell-product',
        'color': const Color(0xFF1F00FF),
        'ontap': () {
          Get.to(() => Withdraw());
        },
      },
      // {
      //   'title': 'Buy',
      //   'svg': 'more',
      //   'color': const Color(0xFF0FF02F),
      //   'ontap': () {
      //     Get.to(()=> const BuyCrypto());
      //   },
      // },
      // {
      //   'title': 'sell',
      //   'svg': 'more',
      //   'color': const Color(0xFF0FFefF),
      //   'ontap': () {
      //     Get.to(()=> const SellCrypto());
      //   },
      // },
    ];
  }

  Future load() async {
    await Get.find<ProfileController>().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: '${HiveHelper.read(Keys.firstName)}', isHomeScreen: true),
      body: RefreshIndicator(
        onRefresh: () async {
          AuthController authController = Get.find();
          await authController.getBalance();
          await cryptoController.getCryptoBalance("BTC");
          await cryptoController.getAllowedDepositCoins();
          await Get.find<ProfileController>().getUserProfile();
          return Future.value(true);
        },
        // child: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: ListView(
          padding: const EdgeInsets.all(16),
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const SizedBox(height: 20),
            const CustomBalanceCard(),
            const SizedBox(height: 10),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.mainColor.withOpacity(0.08),
                  // border: Border.all(color: AppColors.mainColor)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _buildFirstDashboardShortcuts()),
            const SizedBox(height: 20),
            // Container(
            //   height: 100.h,
            //   child: const CustomAdvertTextSlider(),
            // ),

            // const SizedBox(height: 20),
            Container(
              height: 150.h,
              child: CustomAdvertSliders2(),
            ),

            const Gap(10),
            _buildMarketPricesSection(),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     InkWell(
            //       onTap: () => Get.to(const BillPayments()),
            //       child: Container(
            //         height: 100,
            //         padding: EdgeInsets.all(12),
            //         decoration: BoxDecoration(
            //             color: AppColors.greenColor.withAlpha(22)
            //         ),
            //         child: Column(
            //           children: [
            //             SvgPicture.asset("assets/svgs/home.svg"),
            //             Text('Bill Payment')
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
        // ),
      ),
    );
  }

  /// Function to build Dashboard Shortcuts

  Widget _buildFirstDashboardShortcuts() {
    return GridView.builder(
      shrinkWrap: true, // Ensures it doesn't take infinite height inside Column
      physics:
          const NeverScrollableScrollPhysics(), // Disables GridView scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust columns as needed
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: firstDashboardShortCutData.length,
      itemBuilder: (context, index) {
        final item = firstDashboardShortCutData[index];
        // print(item);
        return GestureDetector(
          onTap: item['ontap'] as VoidCallback?, // Cast ontap as function
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: AppColors.mainColor.withOpacity(0.08),
              // border: Border.all(color: AppColors.mainColor)
            ),
            // padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svgs/${item['svg']}.svg",
                  height: 25,
                  width: 25,
                  color: item['color'],
                ),
                // Icon(Icons.dashboard, size: 40, color: Colors.blue), // Replace with SVG if needed
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarketPricesSection() {
    final controller = Get.find<CryptoController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Market Prices',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    Get.isDarkMode ? AppColors.whiteColor : AppColors.black70,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to a detailed market view
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          // Show loading indicator
          if (controller.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Show mock data if real data not yet available
          if (controller.cryptoList.isEmpty) {
            final cryptoData = [
              {
                'symbol': 'BTC',
                'price': '\$82,757.00',
                'change': '-0.02%',
                'color': Colors.amber,
                'iconData': null,
                'isNegative': true,
              },
              {
                'symbol': 'ETH',
                'price': '\$1,788.91',
                'change': '-0.03%',
                'color': Colors.blueGrey,
                'iconData': Icons.currency_exchange,
                'isNegative': true,
              },
              // Add more mock items if needed
            ];

            return Text("No Crytpo fetched");
            //  ListView.builder(
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: cryptoData.length < 7 ? cryptoData.length : 7,
            //   itemBuilder: (context, index) {
            //     final item = cryptoData[index];
            //     return _buildCryptoItem(
            //       item['symbol'] as String,
            //       item['price'] as String,
            //       item['change'] as String,
            //       item['color'] as Color,
            //       iconData: item['iconData'] as IconData?,
            //       isNegative: item['isNegative'] as bool,
            //     );
            //   },
            // );
          }
          final shownList = controller.cryptoList.sublist(0, 5);
          // Show real data
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: shownList.length,
            itemBuilder: (context, index) {
              final item = shownList[index];

              final price = item.minDepositAmount;
              // != null
              //     ? '\$${item.quote!.usd!.price!.toStringAsFixed(2)}'
              //     : "\$0.00";

              final percentChange = 0.00;
              // item.quote?.usd?.percentChange24h;
              final change = percentChange.toStringAsFixed(2);
              // percentChange != null
              //     ? '${percentChange.toStringAsFixed(2)}%'
              //     : "0.00%";

              final isNegative = (percentChange ?? 0) < 0;

              final colors = {
                'BTC': Colors.amber,
                'ETH': Colors.blueGrey,
                'XRP': Colors.black,
                'SOL': Colors.purple,
                'USDT': Colors.green,
                'USDC': Colors.blue,
                'TRX': Colors.red,
                // Add more if needed
              };

              final icons = {
                'BTC': null,
                'ETH': Icons.currency_exchange,
                'XRP': Icons.currency_exchange,
                'SOL': Icons.currency_exchange,
                'USDT': Icons.monetization_on,
                'USDC': Icons.attach_money,
                'TRX': Icons.trending_down,
                // Add more if needed
              };

              final symbol = item.coin ?? "UNKNOWN";
              final color = colors[symbol] ?? Colors.grey;
              final iconData = icons[symbol];

              return
                  // Text("${item.coinShowName}");
                  _buildCryptoItem(
                symbol,
                price,
                change,
                color,
                iconData: iconData,
                isNegative: isNegative,
              );
            },
          );
        }),

        const SizedBox(height: 20),

        // Add the trading button
        Obx(() {
          return (controller.cryptoList.isEmpty)
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => TradeScreen());
                      // Get.toNamed(RoutesName.buyScreen);
                    },
                    child: Text(
                      'Start Trading Now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
        }),

        Container(
            // height: 400,
            padding: const EdgeInsets.all(5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'My Assets',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 22,
                    fontFamily: "Tsukimi Rounded",
                  ),
                )
              ],
            )),
        Obx(() {
          if (cryptoController.isLoading.value == true) {
            return Container(
                width: 20,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ));
          }
          ;

          if (cryptoController.cryptoBalances.length <= 0) {
            return Container(
                // width: 20,
                alignment: Alignment.center,
                child: Center(
                  child: Text("No Assets Found!"),
                ));
          }
          ;
          return Container(
            height: 400,
            padding: EdgeInsets.all(5),
            child: ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: cryptoController.cryptoBalances.length,
              itemBuilder: (context, index) {
                final balance = cryptoController.cryptoBalances[index];
                final balanceData = cryptoController.cryptoBalanceDatas[index];
                final coinMarketcap = cryptoController.coinMarketcap[index];

                double walletBalance =
                    double.parse(balance['walletBalance'].toString());
                double median = double.parse(balanceData['MEDIAN'].toString());

                // Calculate the total
                double total = walletBalance * median;

                print("${balance['coin']} ===   ${balance['walletBalance']}");
                // Ensure that balance is a Map and contains the 'coin' key
                // if (balance is Map<String, dynamic> && balance.con
                //                     // Calculate the total
                //                     double total = walletBalance * median;
                //
                //                         print("${balance['coin']} ===   ${balance['walletBalance']}" );
                //                     // Ensure that balance is a Map and contains the 'coin' key
                //                     // if (balance is Map<String, dynamic> && balance.containsKey('coin')) {
                //                       return Container(
                //                       tainsKey('coin')) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.all(16), // Add some vertical padding
                    decoration: BoxDecoration(
                        color: AppColors.textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18)),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                'https://www.cryptocompare.com/${balanceData['IMAGEURL']}',
                                width: 25,
                                height: 25,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Return the image once it's loaded
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  ); // Show a loading indicator while the image is loading
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  // Return a placeholder widget in case of an error
                                  return Container(
                                    width: 25,
                                    height: 25,
                                    child: Icon(Icons.error,
                                        size: 30,
                                        color: Colors
                                            .red), // Optional: Add an error icon
                                  );
                                },
                              ),
                              Gap(10),
                              Text(
                                coinMarketcap['name'].toString().toUpperCase(),
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Customize text style
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale:
                                      'en_US', // You can change this to your desired locale
                                  symbol: '\$', // Currency symbol
                                  decimalDigits: 2, // Number of decimal places
                                ).format(total),
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Customize text style
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale:
                                    'en_US', // You can change this to your desired locale
                                symbol: '\$', // Currency symbol
                                decimalDigits: 2, // Number of decimal places
                              ).format(double.parse(
                                  balanceData['MEDIAN'].toString())),
                              style: TextStyle(
                                  fontSize:
                                      16), // Optional: Customize text style
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${double.parse(balance['walletBalance'].toString().isEmpty ? '0.00' : balance['walletBalance'].toString())}",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors
                                              .textColor)), // Optional: Customize text style
                                ),
                                Gap(5),
                                Text(
                                  balance['coin'].toString(),
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors
                                              .textColor)), // Optional: Customize text style
                                )
                              ],
                            )
                          ]),
                    ]));
                // } else {
                //   return Container(); // Return an empty container if the data is not valid
                // }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCryptoItem(
      String symbol, String price, String change, Color iconColor,
      {IconData? iconData, required bool isNegative}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconData == null
                      ? const Icon(Icons.currency_bitcoin, color: Colors.white)
                      : Icon(iconData, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isNegative ? Colors.red[400] : Colors.green[500],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Updated Dashboard Data Structure
// final List<Map<String, dynamic>> firstDashboardShortCutData = [
//   {
//     'title': 'Deposit',
//     'svg': 'deposit',
//     'color': Color(0xFFFF00FF),
//     'ontap': () {
//       Get.toNamed(RoutesName.depositScreen);
//     },
//   },
//   {
//     'title': 'Swap',
//     'svg': 'swap',
//     'color': Color(0xffFF8900),
//     'ontap': () {
//       // Get.toNamed(RoutesName.transferTomkrempire);
//       showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.info(
//       message:
//           "There is some information. You need to do something with that",
//     ),
// );
//     },
//   },
//   {
//     'title': 'Withdraw',
//     'svg': 'send',
//     'color': Color(0xffF45521),
//     'ontap': () {
//       Get.toNamed(RoutesName.transferToOtherBank);
//     },
//   },
//   {
//     'title': 'Send',
//     'svg': 'airtime2cash',
//     'color': Color(0xffF45521),
//     'ontap': () {
//       // Get.toNamed(RoutesName.transferToOtherBank);
//     },
//   },
//   {
//     'title': 'Receive',
//     'svg': 'reply',
//     'color': Color(0xFFFF00FF),
//     'ontap': () {
//       // Get.toNamed(RoutesName.depositScreen);
//     },
//   },
//   {
//     'title': 'Giftcard',
//     'svg': 'giftcard',
//     'color': Color(0xffFF8900),
//     'ontap': () {
//       // Get.toNamed(RoutesName.transferTomkrempire);
//     },
//   },
// ];
