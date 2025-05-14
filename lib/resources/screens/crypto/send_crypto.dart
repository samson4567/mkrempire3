import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_pop_up.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:mkrempire/resources/widgets/customized_textfield.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import '../../../app/helpers/hive_helper.dart';
import '../../../app/helpers/keys.dart';


class SendCrypto extends StatefulWidget {
  @override
  State<SendCrypto> createState() => _SendCryptoState();
}

class _SendCryptoState extends State<SendCrypto> {
  PageController _pageController = PageController();
  CryptoController cryptoController =  Get.find<CryptoController>();
  int _currentStep = 1;
  String? selectedCrypto;
  final List<String> cryptoOptions = ["Bitcoin", "Ethereum", "USDT", "BNB"];
  TextEditingController amountController = TextEditingController();
  String? selectedNetwork;

  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return cryptoController.cryptoBalances.isEmpty ? Container(
            height: 300,
            padding: const EdgeInsets.all(16),
        child: Center(child: Text('You don\'t have sufficient balance to Sell'),),
        ):
        Container(
        height: 300,
        padding: const EdgeInsets.all(16),
            child: ListView.builder(
                itemCount: cryptoController.cryptoBalances.length,
                itemBuilder: (context,int index){
                  var crypto =  cryptoController.cryptoBalances[index];
                  print(crypto);
                  return Container(
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.darkBgColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        title: Text("${crypto['coin']}", style: TextStyle(color:  AppColors.textColor)),
                        onTap: () async {
                          setState(() {
                            selectedCrypto = crypto['coin'];
                            selectedNetwork = null;
                          });
                          cryptoController.withdrawableAmount.value = double.parse(crypto['transferBalance']);
                          Navigator.pop(context);
                          cryptoController.getCoinInfo(crypto['coin']);
                          // showNetworkBottomSheet();
                        },
                      ));
                })
        );
      },
    );
  }

  void showNetworkBottomSheet() {
    // if (selectedCrypto == null || !cryptoNetworks.containsKey(selectedCrypto)) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
            itemCount: cryptoController.networkList.length,
            itemBuilder: (context,int index){
              var network =  cryptoController.networkList[index];
              // print(crypto);
              return Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.darkBgColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    title: Text("${network.chainType}", style: TextStyle(color:  AppColors.textColor)),
                    onTap: () async{
                      cryptoController.selectedNetwork = network;
                      setState(() {
                        selectedNetwork = network.chainType;
                        // selectedNetwork = c;
                      });
                      Navigator.pop(context);
                      await cryptoController.deposit(selectedCrypto!,network.chain);
                      // showNetworkBottomSheet();
                      //          CustomDialog.showSuccess(context: context, message: '${
                      // cryptoController.selectedNetwork.chain}', buttonText: 'buttonText');
                      //          print(cryptoController.selectedNetwork);
                    },
                  ));
            });
      },
    );
  }


  void nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  AppBar CustomizedAppBar() {
    return AppBar(
      // backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: previousStep,
      ),
      title: Text(
        '$_currentStep of 3',
        style: GoogleFonts.openSans(
          textStyle: TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 14)),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  void _init() async{
    WidgetsBinding.instance.addPostFrameCallback((_){

      // Add Your Code here.
      cryptoController.amountController = TextEditingController();
      cryptoController.addressController = TextEditingController();
      // await cryptoController.getCryptoBalance("USDT,USDC,ETH,BTC,SOL");

    });
  }
  Future<void> _refresh() async{
    _init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomizedAppBar(),
        body: RefreshIndicator(
          onRefresh: _refresh, // Define this function to refresh data
          child:SafeArea(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                stepOne(),
                stepTwo(),
                stepThree(),
              ],
            ),
          ),
          // backgroundColor: Colors.black,
        ));
  }

  // Step 1 - Select Crypto
  Widget stepOne() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sell Crypto",
              style: TextStyle(fontSize: 30)),
          Gap(30),
          Obx((){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  // onTap: (){
                  //   cryptoController.showCryptoWithdrawal.value = true;
                  // },

                  child: Column(
                    children: [
                      Text('Crypto',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: cryptoController.showCryptoWithdrawal != true ? AppColors.textColor:
                                AppColors.whiteColor
                            ),
                          )),
                      // Gap(5),
                      // cryptoController.showCryptoWithdrawal != true ? Container() :
                      // Container(
                      //   height: 10,
                      //   width: 10,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       color: AppColors.tertiaryColor
                      //   ),
                      // )
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: (){
                //     cryptoController.showCryptoWithdrawal.value = false;
                // },
                //   child: Column(
                //     children: [
                //       Text('Fiat',
                //           style: GoogleFonts.openSans(
                //             textStyle: TextStyle(
                //                 color: cryptoController.showCryptoWithdrawal != true ? AppColors.textColor:
                //                     AppColors.whiteColor
                //             ),
                //           )),
                //       Gap(5),
                //       cryptoController.showCryptoWithdrawal != true ? Container(
                //         height: 10,
                //         width: 10,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             color: AppColors.tertiaryColor
                //         ),
                //       ) : Container(),
                //     ],
                //   ),
                // )
              ],
            );
          }),

          // Gap(30),
          cryptoStepOne()


        ],
      ),
    );
  }

  // Step 2 - Enter Deposit Amount
  Widget stepTwo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Obx((){
        return cryptoController.showCryptoWithdrawal.value == true ?
        cryptoStepTwo() : fiatStepTwo();
      }),


    );
  }

  // Step 3 - Confirm Deposit
  Widget stepThree() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 0),
      child: Obx((){
        return cryptoController.showCryptoWithdrawal.value == true ?
        cryptoStepThree() : fiatStepThree();
      }),
    );
  }


  Widget cryptoStepOne(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20),
            decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(30),
                borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Crypto Balance'),
                    GestureDetector(
                      onTap: () =>showCryptoBottomSheet(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withOpacity(0.1),
                          // border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCrypto ?? "Select",
                              style: TextStyle(
                                fontSize: 16,
                                // color: selectedCrypto != null ? Colors.white : Colors.white54,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Gap(20),
                Obx((){
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${cryptoController.withdrawableAmount.value} ",
                          style: GoogleFonts.tsukimiRounded(
                              textStyle: TextStyle(
                                fontSize: 25,
                              )
                          ),
                        ),

                        Text(selectedCrypto ?? "",
                          style: GoogleFonts.tsukimiRounded(
                              textStyle: TextStyle(
                                fontSize: 18,
                              )
                          ),
                        )
                      ]);
                }),
                Gap(10),
                // Row(
                //        mainAxisAlignment: MainAxisAlignment.center,
                //        children: [
                //          Text('\$0.00',
                //            style: GoogleFonts.openSans(
                //                textStyle: TextStyle(
                //                  fontSize: 18,
                //                )
                //            ))
                //    ],
                //  ),
              ],
            ),
          ),
          SizedBox(height: 26),
          Text(
            'Enter Amount',
            style: GoogleFonts.openSans(
                textStyle: TextStyle(

                )
            ),
          ),
          Gap(10),
          CustomizedTextfield(
            controller: cryptoController.amountController,
            style: GoogleFonts.tsukimiRounded(
                textStyle: TextStyle(
                  fontSize: 20,
                )
            ),
            suffixIcon: InkWell(
              onTap: (){
                cryptoController.amountController.text =cryptoController.withdrawableAmount.value.toString();
              },
              child: Text('Max',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: AppColors.tertiaryColor,
                  ),
                ),
              ),
            ),
            hintText: "Amount",
          ),

          Spacer(),

          Obx((){
            return  CustomAppButton(
              bgColor:cryptoController.amountController.text.isNotEmpty ? selectedCrypto != null ? AppColors.tertiaryColor : AppColors.greyColor: AppColors.greyColor,
              isLoading: cryptoController.isLoading.value == true,
              onTap:cryptoController.isLoading.value != true ? cryptoController.amountController.text.isNotEmpty ? selectedCrypto != null ? nextStep : null: null: null,
              text: "Continue",
            );
          }),
        ],
      ),
    );
  }

  Widget fiatStepOne(){
    return
      Obx((){
        return  CustomAppButton(
          bgColor: selectedCrypto != null ? AppColors.tertiaryColor : AppColors.greyColor,
          isLoading: cryptoController.isLoading.value == true,
          onTap:cryptoController.isLoading.value != true ? selectedCrypto != null ? nextStep : null: null,
          text: "Continue",
        );
      });
  }

  Widget cryptoStepTwo(){
    return Container(
      height: 300,
      // padding: Pa,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SizedBox(height: 6),
          Text("Sell Crypto",
              style: TextStyle(fontSize: 30)),
          SizedBox(height: 36),
          Center(
            child: Container(
                width: 100.w,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.greenColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(22)
                ),
                child:  Text("$selectedCrypto",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                )
            ),
          ),


          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: Colors.black,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Amount to Sell', style: GoogleFonts.openSans(
                        color: AppColors.textColor
                    ),),

                  ],
                ),
                Gap(5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cryptoController.amountController.text,
                        style: GoogleFonts.tsukimiRounded(
                            textStyle: TextStyle(
                              fontSize: 25,
                            )
                        ),
                      ),

                      Text(' $selectedCrypto',
                        style: GoogleFonts.tsukimiRounded(
                            textStyle: TextStyle(
                              fontSize: 18,
                            )
                        ),
                      )
                    ]),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('\$0.00',
                    //     style: GoogleFonts.openSans(
                    //         textStyle: TextStyle(
                    //           fontSize: 18,
                    //         )
                    //     ))
                  ],
                ),
              ],
            ),
          ),
          const Gap(30),
          const Text("Select Network", style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: ()=> showNetworkBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(color: Colors.white24, width: 1), // Only bottom border
                  top: BorderSide.none, // No top border
                  left: BorderSide.none, // No left border
                  right: BorderSide.none, // No right border
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedNetwork ?? "Select Network",
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedNetwork != null ? Colors.white : Colors.white54,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white54),
                ],
              ),
            ),
          ),
          Gap(30),
          Text('Wallet Address',
            style: GoogleFonts.openSans(
                color: AppColors.textColor
            ),
          ),
          CustomizedTextfield(
            controller: cryptoController.addressController,
            hintText: 'Recipient wallet address',
          ),
          Spacer(),
          Obx(() {
            return CustomAppButton(
              bgColor: cryptoController.depositAddressModel.addressDeposit != "" ? AppColors.tertiaryColor : AppColors.greyColor,
              isLoading: cryptoController.isLoading.value == true,
              onTap: cryptoController.isLoading.value != true ?cryptoController.depositAddressModel.addressDeposit != "" ? nextStep : null: null,
              text: 'Continue',
            );
          }),
        ],
      ),
    );
  }


  Widget fiatStepTwo(){
    return Text('Fiat 2');
  }
  Widget cryptoStepThree(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text("Confirm Transaction",
            style: TextStyle(fontSize: 30)),
        SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // color: Colors.black,
              borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount to Sell', style: GoogleFonts.openSans(
                      color: AppColors.textColor
                  ),),

                ],
              ),
              Gap(5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cryptoController.amountController.text,
                      style: GoogleFonts.tsukimiRounded(
                          textStyle: const TextStyle(
                            fontSize: 25,
                          )
                      ),
                    ),

                    Text(' $selectedCrypto',
                      style: GoogleFonts.tsukimiRounded(
                          textStyle: TextStyle(
                            fontSize: 18,
                          )
                      ),
                    )
                  ]),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text('\$0.00',
                  //     style: GoogleFonts.openSans(
                  //         textStyle: TextStyle(
                  //           fontSize: 18,
                  //         )
                  //     ))
                ],
              ),
            ],
          ),
        ),
        Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Coin'),
            Text("${selectedCrypto}")
          ],
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Wallet Address'),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                "${cryptoController.addressController.text}",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                textAlign: TextAlign.end,
                maxLines: 2, // Allow up to 2 lines
                softWrap: true, // Enable soft wrapping
                overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
              ),
            )
          ],
        ),
        Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Wallet Name'),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text("${HiveHelper.read(Keys.user)['firstname']}  ${HiveHelper.read(Keys.user)['lastname']}",
                  textAlign: TextAlign.end,
                  maxLines: 2, // Allow up to 2 lines
                  softWrap: true, // Enable soft wrapping
                  overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                )
            )
          ],
        ),
        Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Network'),
            Text("${cryptoController.depositAddressModel.chainType}")
          ],
        ),
        Gap(20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('Amount you\'ll receive '),
        //     Text("2,000 USDT")
        //   ],
        // ),
        Spacer(),
        CustomAppButton(
          isLoading: cryptoController.isLoading.value,
          onTap: ()async{
            // Get.back();
            await cryptoController.withdraw(context, selectedCrypto, cryptoController.depositAddressModel.chain, cryptoController.addressController.text, cryptoController.amountController.text);
            print('Success');
          },
          text: 'Done',
          bgColor: AppColors.greenColor,
        ),
      ],
    );
  }
  Widget fiatStepThree(){
    return Text('Fiat 3');
  }
}
