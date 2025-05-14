import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/supportController.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:get/get.dart';

import '../../widgets/custom_dialog.dart';

class SupportsScreen extends StatefulWidget {
  const SupportsScreen({super.key});

  @override
  State<SupportsScreen> createState() => _SupportsScreenState();
}

class _SupportsScreenState extends State<SupportsScreen> {
  final Supportcontroller supportcontroller = Get.put(Supportcontroller());
  TextEditingController messageControlller = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  var subjectName = ''.obs;
  var messageName = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Support',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            children: [
              Obx(() {
                if (supportcontroller.isLoading.value == true) {
                  return CustomLoading();
                } else if (supportcontroller.tickets.isEmpty) {
                  Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      Get.dialog(Stack(
                        children: [
                          AlertDialog(
                            title: Text(
                              'Create a Ticket',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  controller: subjectController,
                                  hintText: 'Enter Subject',
                                  maxLength: 100,
                                  onChanged: (v) {
                                    subjectName.value = v;
                                  },
                                ),
                                30.verticalSpace,
                                Container(
                                  width: double.infinity,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.r))),
                                  child: CustomTextField(
                                    expands: true,
                                    maxlines: null,
                                    controller: messageControlller,
                                    hintText: 'Enter Message',
                                    onChanged: (v) {
                                      messageName.value = v;
                                    },
                                  ),
                                ),
                                15.verticalSpace,
                              ],
                            ),
                            actions: [
                              Obx(() => CustomAppButton(
                                    bgColor: subjectName.value.isEmpty ||
                                            messageName.value.isEmpty
                                        ? Get.isDarkMode
                                            ? AppColors.secondaryColor
                                                .withOpacity(0.3)
                                            : AppColors.mainColor
                                                .withOpacity(0.3)
                                        : Get.isDarkMode
                                            ? AppColors.secondaryColor
                                            : AppColors.mainColor,
                                    onTap: subjectName.value.isEmpty ||
                                            messageName.value.isEmpty
                                        ? null
                                        : () {
                                            supportcontroller.createTicket(
                                                data: {
                                                  'subject': subjectName.value,
                                                  'message': messageName.value
                                                });
                                            subjectName.value = '';
                                            messageName.value = '';
                                            messageControlller.clear();
                                            subjectController.clear();
                                            Get.back();
                                          },
                                  ))
                            ],
                          ),
                          Positioned(
                            right: 50,
                            top: 150,
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(Icons.close,
                                  color: Get.isDarkMode
                                      ? AppColors.secondaryColor
                                      : AppColors.mainColor,
                                  size: 24),
                            ),
                          ),
                        ],
                      ));
                    },
                  );

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        250.verticalSpace,
                        Text(
                          'No Tickets Available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ); // Default return widget
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: supportcontroller.tickets.length,
                    itemBuilder: (context, index) {
                      final support = supportcontroller.tickets[index];
                      return ListTile(
                        title: Text(
                          support['subject'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          support['status'],
                          style: TextStyle(
                              color: support['status'] == 'Open'
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.r)),
                              ),
                              builder: (BuildContext context) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 200.h,
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Are you sure you want to delete this ticket?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                        20.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomAppButton(
                                              buttonWidth: 100,
                                              bgColor: Colors.grey,
                                              onTap: () {
                                                Get.back();
                                                Get.back();
                                              },
                                              text: 'Cancel',
                                            ),
                                            CustomAppButton(
                                              buttonWidth: 100,
                                              bgColor: Colors.red,
                                              onTap: () {
                                                supportcontroller
                                                    .deleteTickets(support['id']
                                                        .toString())
                                                    .then((_) {
                                                  Get.back();
                                                });
                                              },
                                              text: 'Delete',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: 20.sp,
                          ),
                        ),
                      );
                    },
                  );
                }
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Stack(
                children: [
                  AlertDialog(
                    title: Text(
                      'Create a Ticket',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: subjectController,
                          hintText: 'Enter Subject',
                          maxLength: 100,
                          onChanged: (v) {
                            subjectName.value = v;
                          },
                        ),
                        30.verticalSpace,
                        Container(
                          width: double.infinity,
                          height: 100.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.r))),
                          child: CustomTextField(
                            expands: true,
                            maxlines: null,
                            controller: messageControlller,
                            hintText: 'Enter Message',
                            onChanged: (v) {
                              messageName.value = v;
                            },
                          ),
                        ),
                        15.verticalSpace,
                      ],
                    ),
                    actions: [
                      Obx(() => CustomAppButton(
                            bgColor: subjectName.value.isEmpty ||
                                    messageName.value.isEmpty
                                ? Get.isDarkMode
                                    ? AppColors.secondaryColor.withOpacity(0.3)
                                    : AppColors.mainColor.withOpacity(0.3)
                                : Get.isDarkMode
                                    ? AppColors.secondaryColor
                                    : AppColors.mainColor,
                            onTap: subjectName.value.isEmpty ||
                                    messageName.value.isEmpty
                                ? null
                                : () {
                                    supportcontroller.createTicket(data: {
                                      'subject': subjectName.value,
                                      'message': messageName.value
                                    });
                                    subjectName.value = '';
                                    messageName.value = '';
                                    messageControlller.clear();
                                    subjectController.clear();
                                    Get.back();
                                  },
                          ))
                    ],
                  ),
                  Positioned(
                    right: 50,
                    top: 150,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: Get.isDarkMode
                            ? AppColors.secondaryColor
                            : AppColors.mainColor.withOpacity(0.5),
                        size: 24.sp,
                        weight: 5,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor:
            Get.isDarkMode ? AppColors.secondaryColor : AppColors.mainColor,
        child: Icon(
          Icons.create,
          size: 30.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
