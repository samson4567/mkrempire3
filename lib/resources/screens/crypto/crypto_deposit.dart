import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/config/app_contants.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_pop_up.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/helpers/hive_helper.dart';
import '../../../app/helpers/keys.dart';
// import '../history_screen.dart';


class CryptoDeposit extends StatefulWidget {
  @override
  State<CryptoDeposit> createState() => _CryptoDepositState();
}

class _CryptoDepositState extends State<CryptoDeposit> {
  PageController _pageController = PageController();
  CryptoController cryptoController =  Get.find<CryptoController>();
  int _currentStep = 1;
  bool iscrypto = true;
  String? selectedCrypto;
  final List<String> cryptoOptions = ["Bitcoin", "Ethereum", "USDT", "BNB"];
  TextEditingController amountController = TextEditingController();
  String? selectedNetwork;
  final Map<String, List<String>> cryptoNetworks = {
    "Bitcoin": ["Bitcoin Mainnet"],
    "Ethereum": ["Ethereum Mainnet"],
    "USDT": ["ERC-20", "TRC-20", "BEP-20"],
    "BNB": ["BEP-2", "BEP-20"],
  };


  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
                  itemCount: cryptoController.cryptoList.length,
                  itemBuilder: (context,int index){
                    var crypto =  cryptoController.cryptoList[index];
                    // print(crypto);
                    return Container(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.darkBgColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(12)
                      ),
                        child: ListTile(
                        title: Text("${crypto.coin}", style: const TextStyle()),
                        onTap: () async {
                          setState(() {
                            selectedCrypto = crypto.coin;
                            selectedNetwork = null;
                          });
                          Navigator.pop(context);
                          cryptoController.getCoinInfo(crypto.coin);
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return cryptoController.networkList.isEmpty ?
        const Center(child: Text("Kindly select crypto"),):
          ListView.builder(
            itemCount: cryptoController.networkList.length,
            itemBuilder: (context,int index){
              var network =  cryptoController.networkList[index];
              // print(crypto);
              return Container(
                  padding: const EdgeInsets.all(6),
                  margin:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    title: Text("${network.chainType}", style: const TextStyle()),
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

      await cryptoController.getAllowedDepositCoins();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(),
      body: SafeArea(
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
    );
  }

  // Step 1 - Select Crypto
  Widget stepOne() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Deposit", style: TextStyle( fontSize: 30)),
          SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //      InkWell(
          //       onTap:(){
          //         setState(() {
          //           iscrypto = true;
          //         });
          //       },
          //         child: const Text('Crypto')),
          //      Gap(30),
          //      InkWell(
          //         onTap:(){
          //           setState(() {
          //             iscrypto = false;
          //           });
          //           },
          //         child: Text('Fiat')),
          //   ],
          // ),
          // Wrap the crypto widget in a SingleChildScrollView or give it a fixed height
          Expanded(
            child: iscrypto ? crypto() : fiat(),
          ),
        ],
      ),
    );
  }


  // Step 1 - Select Crypto
  Widget crypto() {
    // return SingleChildScrollView(
    //     physics: BouncingScrollPhysics(),
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text("Select Crypto", style: TextStyle()),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () =>showCryptoBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mainColor.withAlpha(40)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCrypto ?? "Select Crypto",
                    style: const TextStyle(
                      fontSize: 16,
                      // color: selectedCrypto != null ? Colors.white : Colors.white54,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, ),
                ],
              ),
            ),
          ),


          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [

              // SizedBox(height: 6),
              // Text("Deposit Crypto",
              //     style: TextStyle(fontSize: 30)),
              // const SizedBox(height: 36),
              // selectedCrypto == null ? const SizedBox() :Center(
              //   child: Container(
              //       width: 100.w,
              //       alignment: Alignment.center,
              //       padding: const EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //           color: AppColors.greenColor.withOpacity(0.3),
              //           borderRadius: BorderRadius.circular(22)
              //       ),
              //       child:  Text("$selectedCrypto",
              //         style: GoogleFonts.openSans(
              //             textStyle: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 23,
              //             )
              //         ),
              //       )
              //   ),
              // ),
              Gap(30),
              // Text("Select Network", style: TextStyle()),
              SizedBox(height: 8),
              GestureDetector(
                onTap: ()=> showNetworkBottomSheet(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColor.withAlpha(40)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedNetwork ?? "Select Network",
                        style: const TextStyle(
                          fontSize: 16,
                          // color: selectedNetwork != null ? Colors.white : Colors.white54,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Obx(() {
                return CustomAppButton(
                  bgColor: cryptoController.depositAddressModel.addressDeposit != "" ? AppColors.greenColor : AppColors.greyColor,
                  isLoading: cryptoController.isLoading.value == true,
                  onTap: cryptoController.isLoading.value != true ?cryptoController.depositAddressModel.addressDeposit != "" ? nextStep : null: null,
                  text: 'Continue',
                );
              }),
          //   ],
          // )


          // Spacer(),
          //
          // Obx((){
          //   return  CustomAppButton(
          //     bgColor: selectedCrypto != null ? AppColors.mainColor : AppColors.greyColor,
          //     isLoading: cryptoController.isLoading.value == true,
          //     // onTap: (){
          //     //
          //     //   print(cryptoController.dashboardData);
          //     // },
          //     onTap:cryptoController.isLoading.value != true ? selectedCrypto != null ? nextStep : null: null,
          //     text: "Continue",
          //   );
          // }),
        ],
      // ),
    );
  }
  // Step 1 - Fiat
  Widget fiat() {
    // return Padding(
    //   padding: EdgeInsets.all(16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [

    return  ListView(
            padding: EdgeInsets.all(16),
            // physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(16),
                // height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: AppColors.whiteColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppConstants.appName} Account Number',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "${cryptoController.dashboardData['user']['account_number']}",
                      style: TextStyle(fontSize: 34.sp),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${cryptoController.dashboardData['user']['bank_name']} - ${cryptoController.dashboardData['user']['account_name']}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomAppButton(
                          text: 'Copy account',
                          borderRadius: BorderRadius.all(Radius.circular(32.r)),
                          buttonWidth: 150.w,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.whiteColor,
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: "${cryptoController.dashboardData['user']['account_number']}"));
                            CustomDialog.showSuccess(
                                context: context,
                                message: "Copied Successfully",
                                title: 'Success',
                                buttonText: 'close');
                          },
                        ),
                        CustomAppButton(
                          text: 'Share Details',
                          buttonWidth: 150.w,
                          borderRadius: BorderRadius.all(Radius.circular(32.r)),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.whiteColor,
                          ),
                          onTap: () async {
                            final sharetext = '''
                     Account Number
                    Account Number : ${cryptoController.dashboardData['user']['account_number']},
                    Bank Name: ${cryptoController.dashboardData['user']['bank_name']} ,
                    Full Name: ${cryptoController.dashboardData['user']['account_name']} 
''';
                            await Share.share(sharetext);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  // height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: AppColors.whiteColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'This is a virtual wallet use for deposit of Nigeria naira ',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'interest, bonuses,payouts, from other banks and wallets & proceeds from investments are all paid into this wallet',
                      //   style: TextStyle(fontSize: 14.sp),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'You can transfer from your bank account to this wallet instantly with the account number above',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  )),

            ],
          // ),


      //   ],
      // ),
    );
  }

  // Step 2 - Enter Deposit Amount
  Widget  stepThree() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SizedBox(height: 6),
          Text("Deposit Crypto",
              style: TextStyle(fontSize: 30)),
          SizedBox(height: 36),
          Center(
            child: Container(
              width: 100.w,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(22)
              ),
              child:  Text("$selectedCrypto",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                )
              ),
              )
            ),
          ),
          Gap(30),
          Text("Select Network", style: TextStyle()),
          SizedBox(height: 8),
          GestureDetector(
            onTap: ()=> showNetworkBottomSheet(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
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
                  Icon(Icons.arrow_drop_down, ),
                ],
              ),
            ),
          ),
          Spacer(),
    Obx(() {
      return CustomAppButton(
        bgColor: cryptoController.depositAddressModel.addressDeposit != "" ? AppColors.greenColor : AppColors.greyColor,
        isLoading: cryptoController.isLoading.value == true,
        onTap: cryptoController.isLoading.value != true ?cryptoController.depositAddressModel.addressDeposit != "" ? nextStep : null: null,
        text: 'Continue',
      );
    }),
        ],
      ),
    );
  }

  // Step 3 - Confirm Deposit
  Widget stepTwo() {
    return Padding(
      padding: EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text("Confirm Transaction",
              style: TextStyle(fontSize: 30)),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(vertical: 22),
            margin: EdgeInsets.symmetric(vertical: 22),

            decoration: BoxDecoration(
              color: AppColors.textColor.withAlpha(12),
              borderRadius: BorderRadius.circular(12)
            ),
            // height: ,
          ),

          // QR Code Widget
          Center(
            child: QrImageView(
              data: "${cryptoController.depositAddressModel.addressDeposit}",
              version: QrVersions.auto,
              size: 300.0,
              backgroundColor: Colors.white,
            ),
          ),

          Gap(30),
          SizedBox(height: 16),
          Text('Wallet Address',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: AppColors.textColor
            )
          ),
          ),

    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SelectableText(
            cryptoController.depositAddressModel.addressDeposit ?? "Generating...",
            // style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            if (cryptoController.depositAddressModel.addressDeposit != null) {
              Clipboard.setData(ClipboardData(text: cryptoController.depositAddressModel.addressDeposit!));
              showAnimatedPopup(context, "Copied to clipboard");
              // ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("Copied to clipboard")),
              // );
            }
          },
          icon: Icon(Icons.copy, color: AppColors.mainColor),
        ),
      ],
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
              Text('Network'),
              Text("${cryptoController.depositAddressModel.chainType}")
            ],
          ),
    Spacer(),
          CustomAppButton(
            isLoading: cryptoController.isLoading.value,
            onTap: () => Navigator.pop(context),
            text: 'Done',
            bgColor: AppColors.greenColor,
          ),
        ],
      ),
    );
  }
}
