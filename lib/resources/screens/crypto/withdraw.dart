import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_bottomsheet.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/customized_textfield.dart';
import 'package:flutter/services.dart';
import '../../../app/helpers/hive_helper.dart';
import '../../../app/helpers/keys.dart';
import '../others/bottom_nav_bar.dart';


class Withdraw extends StatefulWidget {
  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  PageController _pageController = PageController();
  CryptoController cryptoController =  Get.find<CryptoController>();
  int _currentStep = 1;
  String? selectedCrypto;
  final List<String> cryptoOptions = ["Bitcoin", "Ethereum", "USDT", "BNB"];
  TextEditingController amountController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  String? selectedNetwork;

  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return cryptoController.cryptoBalances.isEmpty ? Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: const Center(child: Text('You don\'t have sufficient balance to withdraw'),),
        ): Container(
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
      // backgroundColor: Colors.black,
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

  void showBankList() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            height: 700,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
                itemCount: cryptoController.bankList.length,
                itemBuilder: (context,int index){
                  var bank =  cryptoController.bankList[index];
                  // print(bank);
                  return Container(
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.darkBgColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        title: Text("${bank['name']}",
                            style: TextStyle(color:  AppColors.textColor)),
                        onTap: () async {
                          cryptoController.selectedBankCode.value  = "${bank['code']}";
                          cryptoController.selectedBankName.value  = "${bank['name']}";

                          // setState(() {
                          //   selectedCrypto = crypto['coin'];
                          //   selectedNetwork = null;
                          // });
                          // cryptoController.withdrawableAmount.value = double.parse(crypto['transferBalance']);
                          Navigator.pop(context);
                          // cryptoController.getBanks();
                          // showNetworkBottomSheet();
                        },
                      ));
                })
        );
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
        icon: Icon(Icons.arrow_back_ios),
        onPressed: previousStep,
      ),
      title: Text(
        '$_currentStep of 3',
        style: GoogleFonts.openSans(
          textStyle: TextStyle(fontSize: 1370),
        ),
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () => Get.to(()=> HistoryScreen()),
      //     child: Text("History", style: TextStyle(color: Colors.red, fontSize: 14)),
      //   ),
      // ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  void _init() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await cryptoController.getBanks();
      cryptoController.selectedBankName.value = 'Select bank';
      cryptoController.selectedBankCode.value = '';
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
          Text("Withdraw",
              style: TextStyle(fontSize: 30)),
          Gap(30),
          // Obx((){
          //   return Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       InkWell(
          //         onTap: (){
          //           cryptoController.showCryptoWithdrawal.value = false;
          //       },
          //         child: Column(
          //           children: [
          //             Text('Fiat',
          //                 style: GoogleFonts.openSans(
          //                   textStyle: TextStyle(
          //                       color: cryptoController.showCryptoWithdrawal != true ? AppColors.textColor:
          //                           AppColors.whiteColor
          //                   ),
          //                 )),
          //             Gap(5),
          //             cryptoController.showCryptoWithdrawal != true ? Container(
          //               height: 10,
          //               width: 10,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(50),
          //                   color: AppColors.tertiaryColor
          //               ),
          //             ) : Container(),
          //           ],
          //         ),
          //       )
          //     ],
          //   );
          // }),

          // Gap(30),
          Obx((){
            return cryptoController.showCryptoWithdrawal.value == true ?
            cryptoStepOne() : fiatStepOne();
          })


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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wallet Balance'),
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

                    selectedCrypto == null ? Gap(1) :Text(selectedCrypto ?? "Select Coin",
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
      Expanded(
        child: ListView(
          children: [

            GestureDetector(
              onTap: () =>showBankList(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withOpacity(0.1),
                  // border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx((){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cryptoController.selectedBankName.value,
                        style: TextStyle(
                          fontSize: 16,
                          // color: selectedCrypto != null ? Colors.white : Colors.white54,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  );
                }),
              ),
            ),
            Gap(30),
            CustomizedTextfield(
              hintText: 'Account Number',
              controller: accountNumberController,
            ),
            Gap(30),
             CustomizedTextfield(
              hintText: 'Amount',
              controller: amountController,
            ),
            Gap(30),
            Obx((){//
              return  CustomAppButton(
                // bgColor: selectedCrypto != null ? AppColors.tertiaryColor : AppColors.greyColor,
                isLoading: cryptoController.isLoading.value == true,
                // onTap:cryptoController.isLoading.value != true ? selectedCrypto != null ? nextStep : null: null,
                onTap: () async{
                  if(amountController.text.isEmpty || accountNumberController.text.isEmpty ||
                  cryptoController.selectedBankCode.value.isEmpty
                  ){
                    CustomDialog.showWarning(context: context, message: 'Please fill all the fields',
                        buttonText: 'Cancel');
                  }else {
                    print(amountController.text);
                    print(accountNumberController.text);

                    final response = await cryptoController.validate({
                      "account_number": accountNumberController.text,
                      "bank_code": cryptoController.selectedBankCode.value
                    });
                    if(response['success'] == false){
                      CustomDialog.showWarning(context: context, message: '${response['message']}',
                          buttonText: 'Cancel');
                    }else{
                      CustomBottomsheet.showWidget(
                          context: context,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                          child:  Column(
                            children:  [
                              Gap(20),
                              Center(
                                  child: Text('Confirm your transaction')
                              ),
                              Gap(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Account name',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    '${response['data']}',
                                    style: TextStyle(fontSize: 12), // You can adjust the size as needed
                                    softWrap: true,
                                    overflow: TextOverflow.visible, // or use TextOverflow.clip or ellipsis
                                  )

                                ],
                              ),
                              Gap(20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text( 'Bank Name',
                                      style: TextStyle(fontSize: 12)),
                                  Text("${cryptoController.selectedBankName}",
                                      style: TextStyle(fontSize: 12), // You can adjust the size as needed
                                    softWrap: true,
                                    overflow: TextOverflow.visible,),
                                ],
                              ),
                              Gap(20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Account Number ',
                                      style: TextStyle(fontSize: 12)),
                                  Text("${accountNumberController.text}",
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Gap(20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Amount ',
                                      style: TextStyle(fontSize: 12)),
                                  Text("NGN${amountController.text}",
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Gap(40),
                              Obx((){//
                                return  CustomAppButton(
                                  // bgColor: selectedCrypto != null ? AppColors.tertiaryColor : AppColors.greyColor,
                                    isLoading: cryptoController.isLoading.value == true,
                                    // onTap:cryptoController.isLoading.value != true ? selectedCrypto != null ? nextStep : null: null,
                                    onTap: () async{
                                      // Get.back();
                                      Map<String,dynamic>  body = {
                                        "account_number": "${accountNumberController.text}",
                                        "bank_code": "${cryptoController.selectedBankCode}",
                                        "amount":"${amountController.text}",
                                        "account_name": response['data'],
                                        "sender_name": HiveHelper.read(Keys.firstName),
                                        "narration":"Instant Fiat Withdrawal from mkrempire"

                                      };
                                      final withdrawalResponse = await cryptoController.withdrawFiat(body);
                                      Get.back();
                                      if(withdrawalResponse['success'] == true){
                                        CustomDialog.showSuccess(context: context,
                                            message: 'Withdawal successful',
                                            buttonText: 'Home', buttonAction: (){
                                          Get.to(()=>BottomNavBar());
                                            });
                                      }else{

                                        CustomDialog.showError(context: context,
                                            message:  '${withdrawalResponse['message']}',
                                            buttonText: 'Home', buttonAction: (){
                                                  Get.to(()=>BottomNavBar());
                                                  });
                                            // });
                                      }
                                      print('withdrawalResponse $withdrawalResponse');
                                    });
                              }),
                            ],
                          ),
                          )
                      );
                    }
                    print(response);
                  }
                },
                text: "Continue",
              );
            })
          ],
        ),
      );
  }

  Widget cryptoStepTwo(){
    return Container(
      height: 300,
      // padding: Pa,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SizedBox(height: 6),
          Text("Withdraw Crypto",
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
                    Text('Amount to Withdraw', style: GoogleFonts.openSans(
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
                      // color: selectedNetwork != null ? Colors.white : Colors.white54,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
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
                  Text('Amount to Withdraw', style: GoogleFonts.openSans(
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
          onTap: () async{
            // Get.back();
            await cryptoController.withdraw(context, selectedCrypto, cryptoController.depositAddressModel.chain, cryptoController.addressController.text, cryptoController.amountController.text);
            print('Success');
          },
        ),
      ],
    );
  }
  Widget fiatStepThree(){
    return Text('Fiat 3');
  }
}
