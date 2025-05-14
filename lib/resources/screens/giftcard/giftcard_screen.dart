import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkrempire/app/controllers/giftCardController.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/giftCard_repo.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/models/giftcardModels.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_app_button.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_textfield.dart';
import '../others/bottom_nav_bar.dart';

class GiftcardScreen extends StatefulWidget {
  const GiftcardScreen({super.key});

  @override
  State<GiftcardScreen> createState() => _GiftcardScreenState();
}

class _GiftcardScreenState extends State<GiftcardScreen> {
  final Giftcardcontroller giftcardcontroller = Get.put(Giftcardcontroller());
  TextEditingController searchGiftcardController = TextEditingController();
  TextEditingController searchCountryController = TextEditingController();
  TextEditingController receiverEmailController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var currentStep = 1;
  bool isFirstScreenVisible = true;
  bool isSecondScreenVisible = false;
  bool isThirdScreenVisible = false;
  bool isFourthScreenVisible = false;
  dynamic orderGiftcardResponse;
  dynamic getRedeemCodeResponse;

  @override
  void initState() {
    super.initState();
    print('InitState called');

    // Initialize the controller data
    _initializeData();

    // Set up a reaction to monitor when countries change
    ever(giftcardcontroller.countries, (_) {
      print('Countries updated, filtering...');
      _filterCountries(query: 'all');
    });
  }

  Future<void> _initializeData() async {
    try {
      await giftcardcontroller.getGiftcardCountries();
      print('Countries loaded: ${giftcardcontroller.countries.length}');
      _filterCountries(query: 'all');

      await giftcardcontroller.getGiftcards();
      _filterGiftcards();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void setVisible(var index) {
    setState(() {
      if (index == 1) {
        isFirstScreenVisible = true;
        isSecondScreenVisible = false;
        isThirdScreenVisible = false;
        isFourthScreenVisible = false;
        currentStep = 1;
      } else if (index == 2) {
        isSecondScreenVisible = true;
        isFirstScreenVisible = false;
        isThirdScreenVisible = false;
        isFourthScreenVisible = false;
        currentStep = 2;
      } else if (index == 3) {
        isThirdScreenVisible = true;
        isSecondScreenVisible = false;
        isFirstScreenVisible = false;
        isFourthScreenVisible = false;
        currentStep = 3;
      } else {
        isThirdScreenVisible = false;
        isSecondScreenVisible = false;
        isFirstScreenVisible = false;
        isFourthScreenVisible = true;
        currentStep = 4;
      }
    });
  }

  void _filterGiftcards({String query = 'all'}) {
    print('Filtering giftcards with query: $query');

    // First, check if allGiftCards.value is null
    if (giftcardcontroller.allGiftCards.value == null) {
      print('All gift cards is null, initializing empty model');
      // Handle the null case - perhaps initialize an empty model or return early
      giftcardcontroller.filteredGiftCards.value =
          AllGiftcardModel(content: []);
      return;
    }

    final allGiftCardsList =
        giftcardcontroller.allGiftCards.value!.content ?? [];

    // Check if the list is empty to avoid unnecessary processing
    if (allGiftCardsList.isEmpty) {
      print('All gift cards list is empty');
      giftcardcontroller.filteredGiftCards.value =
          AllGiftcardModel(content: []);
      return;
    }

    // Create a list to store filtered cards
    final filteredList = <GiftcarModel>[];

    for (var giftcard in allGiftCardsList) {
      // Check if fixedRecipientDenominations is not empty
      if (giftcard.fixedRecipientDenominations != null &&
          giftcard.fixedRecipientDenominations.isNotEmpty) {
        // Add card to filtered list if it matches query
        if (query == 'all' ||
            giftcard.productName
                .toLowerCase()
                .startsWith(query.toLowerCase())) {
          filteredList.add(giftcard);
        }
      }
    }

    print('Filtered gift cards count: ${filteredList.length}');
    // Update filtered gift cards with the result
    giftcardcontroller.filteredGiftCards.value =
        AllGiftcardModel(content: filteredList);
  }

  void _filterCountries({String query = 'all'}) {
    print('Filtering countries with query: $query');

    // Check if countries list exists and is not empty
    if (giftcardcontroller.countries == null ||
        giftcardcontroller.countries.isEmpty) {
      print('Countries list is null or empty');
      return; // Exit early, nothing to filter
    }

    if (query == 'all') {
      // Show all countries
      giftcardcontroller.filteredCountries.value =
          List.from(giftcardcontroller.countries);
    } else {
      // Filter countries based on query
      giftcardcontroller.filteredCountries.value = giftcardcontroller.countries
          .where((country) => (country.name ?? '')
              .toLowerCase()
              .startsWith(query.toLowerCase()))
          .toList();
    }

    print(
        'Filtered countries count: ${giftcardcontroller.filteredCountries.length}');
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String date = formatter.format(now);
    var formatTime = DateFormat('ss:mmdd;MM-yyyy');
    String time = formatTime.format(now);

    return Scaffold(
        appBar: CustomAppBar(
          isHomeScreen: true,
          title: HiveHelper.read(Keys.firstName),
        ),
        body: Obx(() {
          return giftcardcontroller.isLoading.value == true
              ? CustomLoading()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: isFirstScreenVisible
                      ? Obx(() {
                          // Debug print to check countries value
                          print(
                              'Building UI with countries count: ${giftcardcontroller.countries.length}');
                          print(
                              'Filtered countries count: ${giftcardcontroller.filteredCountries.length}');

                          return giftcardcontroller.countries.isEmpty
                              ? CustomLoading()
                              : Column(
                                  children: [
                                    CustomTextField(
                                      controller: searchCountryController,
                                      onChanged: (query) {
                                        print('Search query: $query');
                                        _filterCountries(query: query);
                                      },
                                      hintText: 'Search countries',
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: giftcardcontroller
                                              .filteredCountries.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            dynamic country = giftcardcontroller
                                                .filteredCountries[index];
                                            return InkWell(
                                              onTap: () async {
                                                await giftcardcontroller
                                                    .getGiftcards(
                                                        countryCode:
                                                            "${country.isoName}");
                                                _filterGiftcards(query: 'all');
                                                print(
                                                    'Selected country: ${country.isoName}');
                                                setVisible(2);
                                              },
                                              child: ListTile(
                                                leading: Container(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.green)),
                                                  child: ClipOval(
                                                      child: SvgPicture.network(
                                                    country.flagUrl.trim(),
                                                    placeholderBuilder:
                                                        (context) => Icon(
                                                      Icons.flag,
                                                      size: 40.sp,
                                                    ),
                                                    width: 40.w,
                                                    height: 40.h,
                                                    fit: BoxFit.cover,
                                                  )),
                                                ),
                                                trailing: Text(
                                                  "${country.currencyCode}",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                title: Text("${country.name}"),
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                );
                        })
                      : isSecondScreenVisible == true
                          ? Obx(() {
                              return giftcardcontroller.allGiftCards.value ==
                                      null
                                  ? CustomLoading()
                                  : giftcardcontroller
                                              .filteredGiftCards.value ==
                                          null
                                      ? Center(
                                          child: Text(
                                              'No Gift card found for this country'), // Show a loader while data is being fetched
                                        )
                                      : ListView(
                                          children: [
                                            CustomTextField(
                                              // hintext: 'Search Giftcard',
                                              // suffixIcon: 'search',
                                              // isSuffixIcon: true,
                                              controller:
                                                  searchGiftcardController,
                                              onChanged: (query) {
                                                print(query);
                                                _filterGiftcards(query: query);
                                              },
                                            ),
                                            SizedBox(
                                                height:
                                                    20), // Add spacing before the GridView
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: giftcardcontroller
                                                      .filteredGiftCards
                                                      .value
                                                      ?.content
                                                      .length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                final giftCard =
                                                    giftcardcontroller
                                                        .filteredGiftCards
                                                        .value!
                                                        .content[index];
                                                print(
                                                    " giftCard.fixedRecipientDenominations.isEmpty -- ${giftCard.fixedRecipientDenominations.isEmpty}");

                                                if (giftCard
                                                    .fixedRecipientDenominations
                                                    .isEmpty) {
                                                  // Handling empty denominations case
                                                  // You might want to decide if you want to show these items or not
                                                }

                                                return ListTile(
                                                  onTap: giftCard
                                                          .fixedRecipientDenominations
                                                          .isEmpty
                                                      ? () => CustomDialog
                                                          .showWarning(
                                                              context: context,
                                                              message:
                                                                  'Gift Card Unavailable for purchase at the moment.',
                                                              buttonText:
                                                                  'Close')
                                                      : () {
                                                          print(
                                                              'Tapped on: ${giftCard.productName}');
                                                          giftcardcontroller
                                                              .selectedGiftCard
                                                              .value = giftCard;
                                                          giftcardcontroller
                                                              .amountInUSD
                                                              .value = giftcardcontroller
                                                                      .selectedGiftCard
                                                                      .value
                                                                      ?.fixedRecipientDenominations![
                                                                  giftcardcontroller
                                                                      .unitPriceIndex
                                                                      .value] *
                                                              giftcardcontroller
                                                                  .quantity
                                                                  .value;
                                                          setVisible(3);
                                                        },
                                                  leading: giftCard
                                                          .logoUrls.isNotEmpty
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            giftCard
                                                                .logoUrls[0],
                                                            fit: BoxFit.cover,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 40),
                                                  title: Text(
                                                    giftCard.productName,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0),
                                                );
                                              },
                                            )
                                          ],
                                        );
                            })
                          : isThirdScreenVisible == true
                              ? ListView(children: [
                                  Gap(50),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          "${giftcardcontroller.selectedGiftCard.value?.logoUrls[0]}",
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit
                                              .cover, // Ensures the image fits well within the circle
                                        ),
                                      ),
                                      20.horizontalSpace,
                                      Expanded(
                                          child: Text(
                                        '${giftcardcontroller.selectedGiftCard.value?.productName}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ))
                                    ],
                                  ),
                                  Gap(30),
                                  CustomTextField(
                                    hintText: 'Receiver\'s email',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      size: 20.sp,
                                    ),
                                    // isPrefixIcon: true,
                                    controller: receiverEmailController,
                                    onChanged: (val) {
                                      setState(() {
                                        receiverEmailController.text = val;
                                      });
                                    },
                                  ),
                                  Gap(15),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                        color: Get.isDarkMode
                                            ? AppColors.secondaryColor
                                                .withOpacity(0.05)
                                            : AppColors.mainColor
                                                .withOpacity(0.05)),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text('Payment Infomation'),
                                        ),
                                        Center(
                                          child: Text(
                                            '${giftcardcontroller.amountInUSD ?? '2.2'} USD',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Get.isDarkMode
                                                    ? AppColors.secondaryColor
                                                    : AppColors.mainColor),
                                          ),
                                        ),
                                        Gap(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Giftcard Name'),
                                            Text(
                                              giftcardcontroller
                                                          .selectedGiftCard
                                                          .value!
                                                          .productName
                                                          .length >
                                                      12
                                                  ? '${giftcardcontroller.selectedGiftCard.value?.productName.substring(0, 12)}...'
                                                  : '${giftcardcontroller.selectedGiftCard.value?.productName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            )
                                          ],
                                        ),
                                        Gap(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Amount'),
                                            Text(
                                                '${giftcardcontroller.ngnRate.value * giftcardcontroller.amountInUSD.value} NGN')
                                          ],
                                        ),
                                        Gap(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Country'),
                                            Text(
                                                '${giftcardcontroller.selectedGiftCard.value?.country['name']}')
                                          ],
                                        ),
                                        Gap(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Quantity'),
                                            Text(
                                                '${giftcardcontroller.quantity.value}')
                                          ],
                                        ),
                                        Gap(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Date'),
                                            Text('${date}')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Gap(15),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Unit Price in (USD)',
                                              style: TextStyle(
                                                  // fontSize: 10
                                                  ),
                                            ),
                                            Gap(10),
                                            // Container(
                                            //   width: 200.w,
                                            //   child: CustomTextField(
                                            //     controller: amountController,
                                            //     onChanged: (val) {
                                            //       setState(() {
                                            //         amountController.text = val;
                                            //       });
                                            //     },
                                            //   ),
                                            // ),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value >
                                                                0
                                                            ? giftcardcontroller
                                                                .unitPriceIndex
                                                                .value--
                                                            : giftcardcontroller
                                                                .unitPriceIndex
                                                                .value;
                                                        giftcardcontroller
                                                            .amountInUSD
                                                            .value = giftcardcontroller
                                                                    .selectedGiftCard
                                                                    .value
                                                                    ?.fixedRecipientDenominations![
                                                                giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value] *
                                                            giftcardcontroller
                                                                .quantity.value;
                                                        //  controller.unitPricelength.value  = controller.selectedGiftCard.value!.fixedRecipientDenominations?.length;
                                                        // var l = controller.selectedGiftCard.value!.fixedRecipientDenominations;
                                                        //  for(var i =0; i <  controller.unitPricelength.value; i++){
                                                        //    controller.unitPrice.value = l![controller.unitPriceIndex.value];
                                                        //    print('i $i - ${controller.unitPrice.value}');
                                                        //    // break;
                                                        //    // controller.unitPriceIndex --;
                                                        //  }
                                                        // controller.unitPrice.value > 1 ? controller.quantity.value-- : controller.quantity.value
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        6.r)),
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .secondaryColor
                                                                : AppColors
                                                                    .mainColor),
                                                        child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                              fontSize: 28.sp,
                                                              color: AppColors
                                                                  .whiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                    20.horizontalSpace,
                                                    Container(
                                                      child: Text(
                                                        '${giftcardcontroller.selectedGiftCard.value?.fixedRecipientDenominations![giftcardcontroller.unitPriceIndex.value] ?? '1.00'}',
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          // color: AppColors.whiteColor
                                                        ),
                                                      ),
                                                    ),
                                                    20.horizontalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        print('d');
                                                        giftcardcontroller
                                                            .unitPricelength
                                                            .value = (giftcardcontroller
                                                                .selectedGiftCard
                                                                .value!
                                                                .fixedRecipientDenominations!
                                                                .length -
                                                            1)!;
                                                        giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value <
                                                                giftcardcontroller
                                                                    .unitPricelength
                                                                    .value
                                                            ? giftcardcontroller
                                                                .unitPriceIndex
                                                                .value++
                                                            : giftcardcontroller
                                                                .unitPriceIndex
                                                                .value;
                                                        giftcardcontroller
                                                            .amountInUSD
                                                            .value = giftcardcontroller
                                                                    .selectedGiftCard
                                                                    .value
                                                                    ?.fixedRecipientDenominations![
                                                                giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value] *
                                                            giftcardcontroller
                                                                .quantity.value;
                                                        // var l = controller.selectedGiftCard.value!.fixedRecipientDenominations;
                                                        // for(var i =0; i <  controller.unitPricelength.value; i++){
                                                        //   // controller.unitPrice.value = l![controller.unitPriceIndex.value];
                                                        //   print('i $i - ${controller.unitPrice.value}');
                                                        //   // break;
                                                        //   // controller.unitPriceIndex --;
                                                        // }
                                                        // controller.unitPrice.value > 1 ? controller.quantity.value-- : controller.quantity.value
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .secondaryColor
                                                                : AppColors
                                                                    .mainColor),
                                                        child: Text(
                                                          '+',
                                                          style: TextStyle(
                                                              fontSize: 28,
                                                              color: AppColors
                                                                  .whiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        20.horizontalSpace,
                                        Column(
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                  // fontSize: 10
                                                  ),
                                            ),
                                            Gap(10),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        giftcardcontroller
                                                                    .quantity
                                                                    .value >
                                                                1
                                                            ? giftcardcontroller
                                                                .quantity
                                                                .value--
                                                            : giftcardcontroller
                                                                .quantity.value;
                                                        giftcardcontroller
                                                            .amountInUSD
                                                            .value = giftcardcontroller
                                                                    .selectedGiftCard
                                                                    .value
                                                                    ?.fixedRecipientDenominations![
                                                                giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value] *
                                                            giftcardcontroller
                                                                .quantity.value;
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .secondaryColor
                                                                : AppColors
                                                                    .mainColor),
                                                        child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                              fontSize: 28,
                                                              color: AppColors
                                                                  .whiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                    20.horizontalSpace,
                                                    Container(
                                                      child: Text(
                                                        '${giftcardcontroller.quantity.value}',
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          // color: AppColors.whiteColor
                                                        ),
                                                      ),
                                                    ),
                                                    20.horizontalSpace,
                                                    InkWell(
                                                      // onTap: ()=>controller.quantity.value ++,
                                                      onTap: () {
                                                        giftcardcontroller
                                                            .quantity.value++;
                                                        giftcardcontroller
                                                            .amountInUSD
                                                            .value = giftcardcontroller
                                                                    .selectedGiftCard
                                                                    .value
                                                                    ?.fixedRecipientDenominations![
                                                                giftcardcontroller
                                                                    .unitPriceIndex
                                                                    .value] *
                                                            giftcardcontroller
                                                                .quantity.value;
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .secondaryColor
                                                                : AppColors
                                                                    .mainColor),
                                                        child: Text(
                                                          '+',
                                                          style: TextStyle(
                                                              fontSize: 28.sp,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Gap(75.h),
                                  CustomAppButton(
                                    text: 'Purchase',
                                    textColor: AppColors.whiteColor,
                                    bgColor:
                                        receiverEmailController.text.isEmpty
                                            ? AppColors.textFieldHintColor
                                            : Get.isDarkMode
                                                ? AppColors.secondaryColor
                                                : AppColors.mainColor,
                                    onTap: receiverEmailController.text.isEmpty
                                        ? null
                                        : () async {
                                            dynamic fields = {
                                              "productId": giftcardcontroller
                                                  .selectedGiftCard
                                                  .value
                                                  ?.productId,
                                              "quantity": giftcardcontroller
                                                  .quantity
                                                  .value, // Extract the value
                                              "unitPrice": giftcardcontroller
                                                      .selectedGiftCard
                                                      .value
                                                      ?.fixedRecipientDenominations![
                                                  giftcardcontroller
                                                      .unitPriceIndex
                                                      .value], // Extract the value for index
                                              "customIdentifier":
                                                  "${HiveHelper.read(Keys.firstName).toString().replaceAll(" ", '')}${time}",
                                              "productAdditionalRequirements": {
                                                "userId": "12"
                                              },
                                              "senderName": HiveHelper.read(
                                                      Keys.firstName)
                                                  .toString(),
                                              "recipientEmail":
                                                  receiverEmailController.text,
                                              "preOrder": false,
                                            };

                                            orderGiftcardResponse =
                                                await giftcardcontroller
                                                    .OrderGiftcards(
                                              fields: fields,
                                            );
                                            if (orderGiftcardResponse[
                                                    'errorCode'] ==
                                                null) {
                                              getRedeemCodeResponse =
                                                  await giftcardcontroller
                                                      .redeemGiftcards(fields: {
                                                "transaction_id":
                                                    orderGiftcardResponse[
                                                        'transactionId']
                                              });
                                              // print(getRedeemCodeResponse);
                                              var message =
                                                  'Your ${giftcardcontroller.selectedGiftCard.value?.productName} card was purchased successfully';
                                              CustomDialog.showSuccess(
                                                  context: context,
                                                  message: message,
                                                  title: 'Giftcard Purchased!',
                                                  buttonText: 'View Gift Card',
                                                  buttonAction: () {
                                                    Get.off(
                                                        () => BottomNavBar());
                                                  });
                                              print("${orderGiftcardResponse}");
                                            } else {
                                              CustomDialog.showError(
                                                context: context,
                                                message:
                                                    ' ${orderGiftcardResponse['errorCode']}',
                                                buttonText: 'Close',
                                              );
                                            }
                                            // print(fields);
                                          },
                                  )
                                ])
                              : Container());
        })
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
