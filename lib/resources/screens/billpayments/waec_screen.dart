import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/waecController.dart';
import 'package:mkrempire/resources/screens/billpayments/purchase.dart';
import 'package:mkrempire/resources/widgets/custom_advert_sliders.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:get/get.dart';

class WaecScreen extends StatefulWidget {
  const WaecScreen({super.key});

  @override
  State<WaecScreen> createState() => _WaecScreenState();
}

class _WaecScreenState extends State<WaecScreen> {
  final Waeccontroller waeccontroller = Get.put(Waeccontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Purchase E-Pins",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Obx(() {
              if (waeccontroller.isLoading.value) {
                return Center(child: CustomLoading());
              } else {
                // Filter only WAEC and NECO items
                final filteredCollection =
                    waeccontroller.collection.where((item) {
                  final name = item['name'].toString().toLowerCase();
                  return name.contains('waec') || name.contains('neco');
                }).toList();

                return filteredCollection.isEmpty
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: 100.h),
                        child: Text(
                          "No items found",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ))
                    : Column(
                        children: [
                          20.verticalSpace,
                          SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredCollection.length,
                                itemBuilder: (context, index) {
                                  final item = filteredCollection[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.h),
                                    child: ListTile(
                                      title: Text(
                                        item['name'] ?? "Unknown",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        "Available: ${item['available']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      trailing: Text(
                                        "₦${item['amount']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                      ),
                                      onTap: () {
                                        Get.to(() => PurchasePins(
                                              id: item['id'],
                                              amount: item['amount'].toString(),
                                            ));
                                      },
                                    ),
                                  );
                                }),
                          ),
                          100.verticalSpace,
                          Container(
                              height: 200.h, child: CustomAdvertSliders()),
                        ],
                      );
              }
            }),
          ),
        ),
      ),
    );
  }
}
