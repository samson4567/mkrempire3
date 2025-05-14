import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_pop_up.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import '../../widgets/customized_textfield.dart';


class SwapScreen extends StatefulWidget {
  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  PageController _pageController = PageController();
  CryptoController cryptoController =  Get.find<CryptoController>();
  int _currentStep = 1;
  String? selectedCrypto;
  final List<String> cryptoOptions = ["Bitcoin", "Ethereum", "USDT", "BNB"];
  TextEditingController amountController = TextEditingController();
  String? selectedNetwork;
  String? swappedCoin;


  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
            itemCount: cryptoController.swapCoinLists.length,
            itemBuilder: (context,int index){
              var network =  cryptoController.swapCoinLists[index];
              // print(crypto);
              return Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.darkBgColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    title: Text("${network['fullName']}", style: TextStyle(color:  AppColors.textColor)),
                    onTap: () async{
                      // cryptoController.selectedNetwork = network;
                      setState(() {
                        swappedCoin = network['coin'];
                      });
                      Navigator.pop(context);
                    },
                  ));
            });
      },
    );
  }


  void nextStep() {
    if (_currentStep < 2) {
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
        '$_currentStep of 2',
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }
  void _init() async{
    await cryptoController.getAllowedDepositCoins();
    await cryptoController.getSwapCoinList();
  }
  @override
  Widget build(BuildContext context) {

    cryptoController.context = context;
    print(cryptoController.swapCoinLists);
    return Scaffold(
      appBar: CustomizedAppBar(),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            stepOne(),
            stepTwo(),
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
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 16),
          Text("Swap",
              style: TextStyle(color: Colors.white,fontSize: 30)),
          SizedBox(height: 16),
          //Image.asset('assets/images/step1.png'),
          SizedBox(height: 16),
          Text("From", style: TextStyle(color: Colors.white38)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () =>showCryptoBottomSheet(),
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
                    selectedCrypto ?? "Select Crypto",
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedCrypto != null ? Colors.white : Colors.white54,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white54),
                ],
              ),
            ),
          ),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(
              width: 40.w,
              padding: EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.tertiaryColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Icon(Icons.swap_vert, size: 30, color: AppColors.darkBgColor,) ,
            )],
          ),
          Gap(20),
          Text("To", style: TextStyle(color: Colors.white38)),
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
                    swappedCoin ?? "Select Network",
                    style: TextStyle(
                      fontSize: 16,
                      color: swappedCoin != null ? Colors.white : Colors.white54,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white54),
                ],
              ),
            ),
          ),
          // const Gap(20),

          Gap(20),
          Text("Enter amount to Swap", style: TextStyle(color: Colors.white38)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){

                  },
                  child: selectedCrypto != null ? Container(
                    child: Row(
                      children: [
                        Text("$selectedCrypto", style: GoogleFonts.tsukimiRounded(
                          textStyle: TextStyle(
                            fontSize: 26,
                            color: AppColors.greenColor
                          )
                        ),),
                        // Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ) : SizedBox(),
                ),
            Expanded(  // Wrap here
                child: CustomizedTextfield(
                  style:GoogleFonts.tsukimiRounded(
                      textStyle: TextStyle(
                          fontSize: 26,
                          color: AppColors.greenColor
                      )
                  ),
                  controller: cryptoController.amountController,
                  // style: GoogleFonts.tsukimiRounded(
                  //     textStyle: TextStyle(
                  //       fontSize: 20,
                  //     )
                  // ),
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

                ),)
              ],
            ),
          ),


          Gap(120),

          Obx((){
            return  CustomAppButton(
              bgColor: selectedCrypto != null ? AppColors.tertiaryColor : AppColors.greyColor,
              isLoading: cryptoController.isLoading.value == true,
              onTap:cryptoController.isLoading.value != true ? selectedCrypto != null ?() async{
                await cryptoController.requestSwapRate(selectedCrypto,swappedCoin,cryptoController.amountController.text);
                print(cryptoController.swapRateLists.value['quoteTxId'] );
                cryptoController.swapRateLists.value['quoteTxId'] ==  null? null : nextStep();
              } : null: null,
              text: "Continue",
            );
          }),
        ],
      ),
    );
  }

  // Step 2 - Enter Deposit Amount
  Widget stepTwo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Obx((){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SizedBox(height: 6),
            Text("Swap Crypto",
                style: TextStyle(color: Colors.white,fontSize: 30)),
            SizedBox(height: 36),
            Center(
              child: Container(
                // width: 100.w,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(22)
                  ),//cryptoController.swapRateLists.value['quoteTxId']
                  child:  Column(
                    children: [
                      Text("You\'ll rceive",
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )
                        ),
                      ),
                      Gap(20),

                      Text(double.parse("${cryptoController.swapRateLists.value['toAmount']}").toStringAsFixed(8),
                        style: GoogleFonts.tsukimiRounded(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            )
                        ),
                      ),
                      Text("${cryptoController.swapRateLists.value['toCoin']}",
                        style: GoogleFonts.openSans(
                            textStyle:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.greenColor
                            )
                        ),
                      )
                    ],
                  )
              ),
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("From",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
                Text("${cryptoController.swapRateLists.value['fromCoin']}",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
              ],
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("To",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
                Text("${cryptoController.swapRateLists.value['toCoin']}",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
              ],
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1 ${cryptoController.swapRateLists.value['toCoin']}",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
                Text("${cryptoController.swapRateLists.value['exchangeRate']}",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
              ],
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("You\'ll receice",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
                Text("${cryptoController.swapRateLists.value['toAmount']}",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
              ],
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expires in",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(cryptoController.swapRateLists.value['expiredTime']))),
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),
            Obx(() {
              return CustomAppButton(
                bgColor:  AppColors.tertiaryColor,
                isLoading: cryptoController.isLoading.value == true,
                onTap: cryptoController.isLoading.value == true ? null : () async {
                  final response =  await cryptoController.swap(cryptoController.swapRateLists.value['quoteTxId']);
                  print('response $response');
                  if(response['status'] == 'error'){
                    CustomDialog.showError(context: this.context,
                        message: response['message'],
                        buttonAction: () async{
                          Get.back();
                          await cryptoController.requestSwapRate(selectedCrypto,swappedCoin,cryptoController.amountController.text);
                        },
                        buttonText: 'Get New Quote');
                  }else{
                    CustomDialog.showSuccess(context: this.context,
                        message: 'Swap successful',
                        buttonAction: (){
                          Get.offAllNamed(RoutesName.bottomNavBar);
                        },
                        buttonText: 'Home');
                  }
                },
                text: 'Continue',
              );
            }),
          ],
        );
      }),
    );
  }

}
