import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/virtualCard_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/virtual_card/virtualCardsList.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:get/get.dart';

class CustomNoVirtualCardBody extends StatefulWidget {
  int currentPage;
  CustomNoVirtualCardBody(
    AppController appController, {
    this.currentPage = 0,
    super.key,
  });

  @override
  State<CustomNoVirtualCardBody> createState() =>
      _CustomNoVirtualCardBodyState();
}

class _CustomNoVirtualCardBodyState extends State<CustomNoVirtualCardBody> {
  final VirtualcardController cardCtrl = Get.put(VirtualcardController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              buidDesign(
                  context: context,
                  icon: 'card',
                  iconColor: Colors.orange,
                  title: 'Instant virtual card',
                  desc:
                      '\$4 Application fee, With low cost for ATM withdrawal and maintenance  and \$2 as minimum balance.'),
              SizedBox(
                height: 20,
              ),
              buidDesign(
                  context: context,
                  icon: 'reply',
                  iconColor: Colors.blue,
                  title: ' Transact with your mkrempire card.',
                  desc: ' Pay online and enjoy seemless payment.'),
              SizedBox(
                height: 20,
              ),
              buidDesign(
                  context: context,
                  icon: 'home',
                  iconColor: Colors.green,
                  title: 'Enjoy seemless payment',
                  desc:
                      'Accepted by 400,000+ online merchants worldwide incuding FACEBOOK, INSTAGRAM,JUMIA and others'),
              SizedBox(
                height: 20,
              ),
              buidDesign(
                  context: context,
                  icon: 'password',
                  iconColor: Colors.red[200],
                  title: 'Security',
                  desc: 'Secured Transactions'),
            ],
          ),
          SizedBox(
            height: 100.h,
          ),
          Container(
              // bottom: 1,
              child: Obx((){
                return CustomAppButton(
                  isLoading: cardCtrl.isLoading.value == true,
                  onTap: () {
                    widget.currentPage == 0
                        ?
                    // Get.to(() => VirtualcardslistScreen())
                    cardCtrl.createVirtualCard(
                      onSuccess: () {
                        Get.to(() => const VirtualcardslistScreen());
                      },
                      customerId: HiveHelper.read(Keys.payscribeId),
                      currency: 'USD',
                      brand: 'MASTERCARD',
                      amount: 4,
                      type: 'virtual',
                    )
                        : cardCtrl.createVirtualCard(
                      onSuccess: () {
                        Get.to(() => const VirtualcardslistScreen());
                      },
                      customerId: HiveHelper.read(Keys.payscribeId),
                      currency: 'USD',
                      brand: 'VISA',
                      amount: 4,
                      type: 'virtual',
                    );
                  },
                  text: widget.currentPage == 0
                      ? 'Apply for MasterCard'
                      : 'Apply for VisaCard',
                  bgColor:
                  Get.isDarkMode ? AppColors.secondaryColor : AppColors.mainColor,
                  textColor: AppColors.whiteColor,
                );
              })),
        ],
      ),
    );
  }

  // Method to add a new card
  Widget buidDesign(
          {required BuildContext context,
          required String icon,
          required dynamic iconColor,
          required String title,
          required String desc}) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/svgs/$icon.svg',
              height: 30,
              width: 30,
              color: iconColor,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    desc,
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      );
}
