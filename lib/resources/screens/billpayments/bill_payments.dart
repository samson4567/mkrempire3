import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/billpayments/waec_screen.dart';
import 'package:mkrempire/resources/screens/others/referralScreen.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BillPayments extends StatefulWidget {
  const BillPayments({super.key});

  @override
  State<BillPayments> createState() => _BillPaymentsState();
}

class _BillPaymentsState extends State<BillPayments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Services',
        isHomeScreen: true,
      ),
      body: SingleChildScrollView(
        child: _buildDashboardShortcuts(),
      ),
    );
  }

  Widget _buildDashboardShortcuts() {
    int itemsPerPage = 12; // 4x4 grid per page
    int totalPages = (dashboardShortCutData.length / itemsPerPage).ceil();
    PageController pageController = PageController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: const [
          //       Text(
          //         'Services',
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 300.h,
            child: PageView.builder(
              controller: pageController,
              itemCount: totalPages,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * itemsPerPage;
                int endIndex = (startIndex + itemsPerPage)
                    .clamp(0, dashboardShortCutData.length);

                final pageItems =
                    dashboardShortCutData.sublist(startIndex, endIndex);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1,
                  ),
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final item = pageItems[index];
                    return GestureDetector(
                      onTap: item['ontap'] as VoidCallback?,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor.withOpacity(0.08),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/${item['svg']}.svg",
                              height: 30,
                              width: 30,
                              color: item['color'],
                            ),
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
              },
            ),
          ),
          // const SizedBox(height: 16),
          // Center(
          //   child: SmoothPageIndicator(
          //     controller: pageController,
          //     count: totalPages,
          //     effect: const WormEffect(
          //       dotHeight: 8,
          //       dotWidth: 8,
          //       activeDotColor: Colors.blue,
          //       dotColor: Colors.grey,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

// class _BillPaymentsState extends State<BillPayments> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: _buildDashboardShortcuts(),
//     );
//   }

//   Widget _buildDashboardShortcuts() {
//     int itemsPerPage = 12; // 4x4 grid per page
//     int totalPages = (dashboardShortCutData.length / itemsPerPage).ceil();
//     PageController pageController = PageController();

//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Services',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     // color: AppColors.mainColor,
//                   ),
//                 ),
//                 // TextButton(
//                 //   onPressed: () {
//                 //     // Action for "More"
//                 //   },
//                 //   child: const Row(
//                 //     children: [
//                 //       Text(
//                 //         'More',
//                 //         style: TextStyle(color: AppColors.whiteColor),
//                 //       ),
//                 //       const Icon(Icons.arrow_forward, size: 16,color: AppColors.whiteColor,),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 300.h, // Adjust height as needed
//             child: PageView.builder(
//               controller: pageController,
//               itemCount: totalPages,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, pageIndex) {
//                 int startIndex = pageIndex * itemsPerPage;
//                 int endIndex = (startIndex + itemsPerPage)
//                     .clamp(0, dashboardShortCutData.length);

//                 // Sublist for the current page
//                 final pageItems =
//                     dashboardShortCutData.sublist(startIndex, endIndex);

//                 return Container(
//                   // padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 6,
//                       mainAxisSpacing: 6,
//                       childAspectRatio: 1,
//                     ),
//                     itemCount: pageItems.length,
//                     itemBuilder: (context, index) {
//                       final item = pageItems[index];
//                       return GestureDetector(
//                         onTap: item['ontap'] as VoidCallback?,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppColors.mainColor.withOpacity(0.08),
//                           ),
//                           padding: const EdgeInsets.all(5),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset(
//                                 "assets/svgs/${item['svg']}.svg",
//                                 height: 30,
//                                 width: 30,
//                                 color: item['color'],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 item['title']!,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Get.isDarkMode
//                                       ? AppColors.whiteColor
//                                       : AppColors.black70,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           Center(
//             child: SmoothPageIndicator(
//               controller: pageController,
//               count: totalPages,
//               effect: const WormEffect(
//                 dotHeight: 8,
//                 dotWidth: 8,
//                 activeDotColor: Colors.blue, // Adjust to match your theme
//                 dotColor: Colors.grey, // Adjust to match your theme
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  /// Updated Dashboard Data Structure
  final List<Map<String, dynamic>> dashboardShortCutData = [
    {
      'title': 'Airtime',
      'svg': 'airtime',
      'color': Color(0xffF45521),
      'ontap': () {
        Get.toNamed(RoutesName.airtimeScreen);
        // print('Airtime tapped');
      },
    },
    {
      'title': 'Data',
      'svg': 'data',
      'color': Color(0xffFF8900),
      'ontap': () {
        // print('Mobile Data tapped');
        Get.toNamed(RoutesName.mobileDataScreen);
      },
    },
    {
      'title': 'Betting',
      'svg': 'bet',
      'color': Color(0xff12B600),
      'ontap': () {
        Get.toNamed(RoutesName.bettingScreen);
      },
    },
    {
      'title': 'Electricity',
      'svg': 'electricity',
      'color': Color(0xffFF8900),
      'ontap': () {
        Get.toNamed(RoutesName.electricityScreen);
        // CustomDialog.showError(context: context, message: message, buttonText: buttonText)
        // print('Electricity tapped');
      },
    },
    {
      'title': 'Cable Tv',
      'svg': 'tv',
      'color': Color(0xff12B600),
      'ontap': () {
        Get.toNamed(RoutesName.cableTvScreen);
        // print('Cable Tv tapped');
      },
    },
    {
      'title': 'Internet',
      'svg': 'internet2',
      'color': Color(0xffF45521),
      'ontap': () {
        Get.toNamed(RoutesName.internetScreen);
        // print('Internet Data tapped');
      },
    },
    {
      'title': 'WAEC / NECO',
      'svg': 'education',
      'color': Colors.amberAccent,
      'ontap': () {
        // print('Educations tapped');
        Get.to(() => WaecScreen());
      },
    },
    // {
    //   'title': 'JAMB',
    //   'svg': 'study',
    //   'color': Color(0xFFd5eb34),
    //   'ontap': () {
    //     // print('mORE tapped');
    //   },
    // },

    // {
    //   'title': 'Airtime2cash',
    //   'svg': 'airtime2cash',
    //   'color': Color(0xffF45521),
    //   'ontap': () {
    //     // print('Airtime tapped');
    //     CustomDialog.showWarning(
    //         context: Get.context!,
    //         message: 'This feature will be available soon',
    //         buttonText: 'Close');
    //   },
    // },
    // {
    //   'title': 'Data2cash',
    //   'svg': 'data2cash',
    //   'color': Color(0xffFF8900),
    //   'ontap': () {
    //     // print('Mobile Data tapped');
    //     CustomDialog.showWarning(
    //         context: Get.context!,
    //         message: 'This feature will be available soon',
    //         buttonText: 'Close');
    //   },
    // },
    // {
    //   'title': 'JAMB UTME',
    //   'svg': 'college',
    //   'color' :Color(0xff12B600),
    //   'ontap': () {
    //    // print('Betting tapped');
    //   },
    // },
    // {
    //   'title': 'JAMB UTME MOCK',
    //   'svg': 'college2',
    //   'color' :Color(0xffFF8900),
    //   'ontap': () {
    //    // print('JAMB UTME MOCK tapped');
    //   },
    // },
    // {
    //   'title': 'JAMB DE',
    //   'svg': 'tv',
    //   'color' :Color(0xff12B600),
    //   'ontap': () {
    //    // print('Cable Tv tapped');
    //   },
    // },
    {
      'title': 'Referral',
      'svg': 'referral',
      'color': Color(0xffF45521),
      'ontap': () {
        // print('Internet Data tapped');
        Get.to(() => ReferralScreen());
      },
    },
    // {
    //   'title': 'Virtual Card',
    //   'svg': 'card',
    //   'color': Color(0xFFFF00FF),
    //   'ontap': () {
    //     NavigationController navigationController = Get.find();
    //     navigationController.changeScreen(2);
    //     // Get.offAll(() => BottomNavBar());
    //   },
    // },
    // {
    //   'title': 'Giftcard',
    //   'svg': 'giftcard',
    //   'color': Color(0xff2F3C7E),
    //   'ontap': () {
    //     // print('mORE tapped');
    //     NavigationController navigationController = Get.find();
    //     navigationController.changeScreen(1);
    //   },
    // },
  ];
}
