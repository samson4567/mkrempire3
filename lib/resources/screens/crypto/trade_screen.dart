import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_contants.dart';
// import 'package:mkrempire/resources/screens/bottom_nav_bar.dart';
import 'package:mkrempire/resources/screens/crypto/buy_crypto.dart';
import 'package:mkrempire/resources/screens/crypto/sell_crypto.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:mkrempire/routes/api_endpoints.dart';
import 'package:pinput/pinput.dart';

import '../../../app/models/CryptoNetworkModel.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_app_button.dart';
import '../../widgets/custom_bottomsheet.dart';


class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key });

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  CryptoController cryptoController  =  Get.find<CryptoController>();
  int _currentScreen = 0;
  int _currentIndex = 0;
  Map<String,dynamic> selectedCrypto = {};
  Map<String,dynamic> selectedNetwork = {};
  TextEditingController amountController = TextEditingController();
  String selectedLogo = '${ApiEndpoints.homeUrl}/assets/upload/gateway/0Bms9NBGKyczQov03x5UeESd7IMpv3.webp';
  // String? selectedNetwork;

  List cryptos = [];
  double amount = 0.00;
  // double buyPrice = 0.00;
  // double sellPrice = 0.00;
  double coinAmount = 0.00;
  double conversionRate = 0.00;
  String pinVal = '';


  Timer? _timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentScreen = 0;
    });
    _init();
  }

  Future<void> _refresh() async {
    print('Refresh starts...');
    _init();
    print('Refresh ends...');
  }

  void _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await cryptoController.gateways();
      cryptos = [];
      setState(() {
        // amountController.text = '0.00';
        cryptos.addAll(response);
        cryptoController.selectedGateway = cryptos[0];
      });
    });
  }


  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
                itemCount: cryptoController.selectedGateway['receivable_currencies'].length,
                itemBuilder: (context,int index){
                  var crypto =  cryptoController.selectedGateway['receivable_currencies'][index];
                  // print(crypto);
                  return Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.darkBgColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        // leading: ClipOval(
                        //   child: Image.network('$selectedLogo',fit: BoxFit.fill,
                        //   height: 40,width: 40,),
                        // ),
                        title: Text("${crypto['currency']}", style: const TextStyle(color:  AppColors.textColor)),
                        onTap: () async {
                          selectedCrypto = {};
                          setState(() {
                            _currentIndex = index;
                            // cryptos.addAll(crypto);
                            // conversionRate = double.parse('${crypto['conversion_rate']}');
                            // buyPrice = double.parse(crypto['buy_price']);
                            // sellPrice =  double.parse(crypto['sell_price']);
                            selectedCrypto.addAll(crypto);
                            // selectedNetwork = null;
                          });
                          update(cryptos[index]);
                          // cryptoController.selectedNetwork = {};
                          cryptoController.selectedNetwork =  Network.fromJson( {
                            "chainType": "",
                            "confirmation": "1",
                            "withdrawFee": "0",
                            "depositMin": "0.001",
                            "withdrawMin": "0",
                            "chain": "",
                            "chainDeposit": "1",
                            "chainWithdraw": "1",
                            "minAccuracy": "4",
                            "withdrawPercentageFee": "0",
                            "contractAddress": ""
                          });
                          // cryptoController.withdrawableAmount.value = double.parse(crypto['transferBalance']);
                          Navigator.pop(context);
                          await cryptoController.getCoinInfo(crypto['currency']);
                          // cryptoController.selectedNetwork.chainType = cryptoController.selectedNetwork[0].chainType;
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
                  margin: EdgeInsets.all( 10),
                  decoration: BoxDecoration(
                      color: AppColors.darkBgColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    title: Text("${network.chainType}", style: TextStyle(color:  AppColors.textColor)),
                    onTap: () async{
                      cryptoController.selectedNetwork = network;
                      setState(() {
                        // selectedNetwork = 'network.chainType';
                        // selectedNetwork = c;
                      });
                      Navigator.pop(context);
                      // await cryptoController.deposit(selectedCrypto!,network.chain);
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

  void update(selectedCrypto){
    // print("image:+====>  ");
    selectedLogo = "${ApiEndpoints.homeUrl}/assets/upload/${selectedCrypto['receivable_currencies'][_currentIndex]['image']['path']}";
    var rate = selectedCrypto['receivable_currencies'][_currentIndex]['conversion_rate'];
    if(conversionRate.toString() != rate.toString()){
      // print('conversionRate $conversionRate');
      print('selectedGateway ${selectedCrypto}');
      setState(() {
        conversionRate = double.parse('$rate');
      });
    }
  }

  void showBuy() {
    setState(() {
      _currentScreen = 0;
      // cryptoController.selectedGateway = cryptos[_currentScreen];
      // print(cryptoController.selectedGateway['receivable_currencies']);
    });
    // print(cryptos[0]);
    update(cryptos[0]);
  }

  void showSell() {
    setState(() {
      _currentScreen = 1;
      // cryptoController.selectedGateway = cryptos[_currentScreen];
      // conversionRate = double.parse('${cryptoController.selectedGateway['receivable_currencies'][0]['conversion_rate']}');
    });
    // print(cryptos[1]);
    update(cryptos[1]);
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    cryptos.isEmpty ? null : cryptoController.selectedGateway = cryptos[_currentScreen];
    // update(cryptos[_currentScreen]['receivable_currencies'][0]);
    print("\n\n_currentScreen ${_currentScreen}");
    return Scaffold(
      appBar: const CustomAppBar(isHomeScreen: false, title: 'Trade', showBackIcon: false,),
      // backgroundColor: AppColors.darkBgColor,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Obx(() {
                //   return
                Center(
                  child: Column(
                    children: [
                      // Text('Available Balance', style: GoogleFonts.openSans()),
                      // Gap(10),
                      // Text("\$${cryptoController.coinBalance.value.toStringAsFixed(4)}", style: GoogleFonts.tsukimiRounded(
                      //     textStyle: TextStyle(
                      //         fontSize: 24,
                      //         color: AppColors.greenColor
                      //     )
                      // )),

                      Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomAppButton(
                            isLoading: cryptoController.selectedGateway['code'] == null,
                            text: 'Sell',
                            onTap: ()=>showSell(),
                            // bgColor: AppColors.greenColor,
                            buttonWidth: MediaQuery.of(context).size.width * 0.45,
                          ),
                          CustomAppButton(
                            isLoading: cryptoController.selectedGateway['code'] == null,
                            text: 'Buy',
                            buttonWidth: MediaQuery.of(context).size.width * 0.45,
                            onTap: ()=>showBuy(),
                            bgColor: AppColors.greenColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // }),
                // _currentScreen == 0 ? buy():
                // sell(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _currentScreen == 0 ? AppColors.greenColor : AppColors.mainColor),
                          // color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Gap(30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipOval(
                                  child: Image.asset("assets/images/ngn.png", width: 40,
                                    height: 40, fit: BoxFit.fill,),
                                ),
                                Gap(20),
                                const Text("Nigerian Naira",
                                    style:  TextStyle( fontSize: 18)),

                              ],
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Gap(10),
                      InkWell(
                        onTap:  cryptoController.selectedGateway['code'] == null ? null : ()=>showCryptoBottomSheet(),
                        child:Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: _currentScreen == 0 ? AppColors.greenColor : AppColors.mainColor),
                            // color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Gap(30),
                                  cryptoController.selectedGateway['image'] == null ? const Gap(1) : ClipOval(
                                    child: Image.network(selectedLogo, width: 30,
                                      height: 30, fit: BoxFit.fill,),
                                  ),
                                  Gap(20),
                                  Text(selectedCrypto['currency'] == null ? "Select Cryto" :"${ selectedCrypto['currency']}",
                                      style:  TextStyle( fontSize: 18)),

                                ],
                              ),

                              Icon(Icons.arrow_drop_down),

                            ],
                          ),
                        ) ,
                      ),
                      const SizedBox(height: 16),

                  Obx(() {
                    return InkWell(
                        onTap:  cryptoController.selectedNetwork.chainType == null ? null : ()=>showNetworkBottomSheet(),
                        child:Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: _currentScreen == 0 ? AppColors.greenColor : AppColors.mainColor),
                            // color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: cryptoController.isLoading.value == true ? const CustomLoading() :  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Gap(30),
                                  cryptoController.selectedGateway['image'] == null ? const Gap(1) : ClipOval(
                                    child: Image.network(selectedLogo, width: 30,
                                      height: 30, fit: BoxFit.fill,),
                                  ),
                                  Gap(20),
                                  Text(cryptoController.selectedNetwork.chainType == null ? "Select Chain" :"${ cryptoController.selectedNetwork.chainType}",
                                      style:  TextStyle( fontSize: 18)),

                                ],
                              ),

                              Icon(Icons.arrow_drop_down),

                            ],
                          ),
                        ) ,
                      );}),
                      const SizedBox(height: 16),

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
                                  Text(_currentScreen == 0 ? "Buy" :'Sell',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: cryptoController.showCryptoWithdrawal != true ? AppColors.textColor:
                                            AppColors.whiteColor
                                        ),
                                      )),
                                  Gap(5),
                                  cryptoController.showCryptoWithdrawal != true ? Container() :
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.mainColor
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),

                      Gap(10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.greyColor.withAlpha(40))
                        ),
                        child: CustomTextField(
                            onChanged: (val){
                              setState(() {
                                amount = double.parse('$val');
                                coinAmount = conversionRate * amount;
                                // buyPrice = amount *
                              });
                              print(coinAmount);
                            },
                            hintText: 'Enter amount',
                            controller: amountController,
                            prefixIcon: Icon(Icons.account_balance_wallet_outlined)
                        ),
                      ),
                      Gap(30),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(color: AppColors.greyColor.withAlpha(40))
                      //   ),
                      //   child: Text(1 == 11 ? '0.00234' : "Coin amount"),
                      // ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(child:  selectedLogo == null ? Gap(1) : Image.network('${selectedLogo}', width: 25, height: 25,),),
                                Gap(20),
                                Text('\$1 = NGN ${
                                    NumberFormat('#,##0.00').format(conversionRate)}')



                              ],
                            )
                          ],
                        ),
                      ),


                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Text(
                          ' = ${NumberFormat('#,##0.00').format(conversionRate * amount)} NGN',
                        ),
                      ),

                      Gap(40),
                      CustomAppButton(
                        isLoading:  cryptoController.selectedGateway['code'] == null,
                        bgColor: _currentScreen == 0 ? AppColors.greenColor : AppColors.mainColor ,
                        text: _currentScreen == 0 ? 'Buy ${ cryptoController.selectedGateway['symbol'] ?? ""}':" Sell ${ cryptoController.selectedGateway['symbol'] ?? ""} ",
                        // onTap: () => CustomDialog.showSuccess(context: context, message: 'Processing...', buttonText: 'Cancel',
                        // buttonAction: ()=>Get.back()

                          // 3c29e4ad-e4eb-4bfe-99c4-0a8b59a97ddc
                        onTap: amountController.text == '' ? ()async {
                          // print('${cryptoController.cryptoBalances}');
                          CustomDialog.showWarning(context: context,
                              message: 'Amount cannot be empty!', buttonText: 'Cancel');
                        } : conversionRate == 0.00 ? (){
                          CustomDialog.showWarning(context: context,
                              message: 'Kindly select crypto!!!', buttonText: 'Cancel');
                        } : ()=>CustomBottomsheet.showWidget(
                            context: context,
                            // backgroundColor: Colors.black,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Gap(20),
                                      Text(' ${ _currentScreen == 0 ? 'Buy': 'Sell'} Crypto Details'),
                                      InkWell(
                                        onTap: () => Get.back(),
                                        child: const Icon(Icons.cancel),
                                      )
                                    ],
                                  ),
                                  const Gap(30),
                                  Center(
                                    child: Text('Enter your transaction pin to continue',
                                      style: GoogleFonts.tsukimiRounded(
                                          textStyle: const TextStyle(
                                              fontSize: 16
                                          )
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     ClipOval(child:  selectedLogo == null ? Gap(1) : Image.network(selectedLogo, width: 25, height: 25,),),
                                  //     Gap(20),
                                  //     Text('\$${amountController.text}'
                                  //         ' (${NumberFormat('#,##0.00').format(conversionRate * amount)} NGN)')
                                  //   ],
                                  // ),

                                  Gap(20),
                                  Pinput(
                                    length: 4,
                                    onChanged: (val){
                                      // print(val);
                                      if(val.length == 4) {
                                        pinVal = val;

                                        print(pinVal);
                                        Get.back();
                                        print(HiveHelper.read(Keys.userPin));
                                        if(pinVal.toString() == HiveHelper.read(Keys.userPin).toString()){
                                          _currentScreen == 0 ?  Get.to(() => BuyCrypto(chainType:cryptoController.selectedNetwork.chainType  ,coin: selectedCrypto['currency'],
                                              rate: '$conversionRate',amount: amountController.text)) :
                                          Get.to(() => SellCrypto(chainType:cryptoController.selectedNetwork.chainType,selectedCrypto: selectedCrypto, coin: selectedCrypto['currency'],
                                              rate: '$conversionRate',amount: amountController.text));
                                          // CustomDialog.showSuccess
                                          //   (
                                          //     context
                                          //         :
                                          //     context,
                                          //     message: 'Hello boss! your transaction has been completed successfully',
                                          //     buttonText: 'Go to home',
                                          //     buttonAction: (){
                                          //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                                          //       }
                                          // );
                                        }
                                        else{
                                          CustomDialog.showError(
                                              context
                                                  :
                                              context,
                                              message:
                                              'Your transaction pin is wrong',
                                              buttonText: 'Try again!',
                                              buttonAction: () => Get.back()
                                          ) ;
                                        }
                                      }
                                    },
                                  ),

                                  const Gap(20),
                                  // CustomAppButton(
                                  //   bgColor:  _currentScreen == 0 ? AppColors.greenColor : AppColors.mainColor,
                                  //   text: 'Continue',
                                  //   onTap:  (){
                                  //     print(pinVal);
                                  //     Get.back();
                                  //     print(HiveHelper.read(Keys.userPin));
                                  //     pinVal.toString() == HiveHelper.read(Keys.userPin).toString()?
                                  //     CustomDialog.showSuccess
                                  //       (
                                  //         context
                                  //             :
                                  //         context,
                                  //         message: 'Hello boss! your transaction has been completed successfully',
                                  //         buttonText: 'Go to home',
                                  //         buttonAction: (){ Get.to(BottomNavBar());}
                                  //     ) :CustomDialog.showError(
                                  //         context
                                  //             :
                                  //         context,
                                  //         message: 'Your transaction pin is wrong',
                                  //         buttonText: 'Try again!',
                                  //         buttonAction: () => Get.back()
                                  //     ) ;
                                  //   }
                                  // )

                                ],
                              ),
                            )
                        ),
                        // ),
                      )
                    ],
                  ),
                ),
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }




  // Step 1 - Select Crypto
  Widget buy() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Buy",
          //     style: TextStyle(fontSize: 30)),
          Gap(30),
          // Ethereum Card
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Image.network("https://cryptocompare.com${cryptoController.ethData['IMAGEURL']}", height: 30),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ethereum",
                          style: GoogleFonts.tsukimiRounded(
                               fontSize: 16),
                        ),
                        Text("${cryptoController.ethData['FROMSYMBOL']}USDT",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$${double.parse('${cryptoController.ethData['MEDIAN'] ?? 0.00}' ?? "0.00").toStringAsFixed(2)}",
                        style: GoogleFonts.tsukimiRounded(
                            
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("${double.parse('${cryptoController.ethData['CHANGEPCT24HOUR'] ?? 0.00}').toStringAsFixed(4)}",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        // const SizedBox(width: 4),
                        // const Icon(Icons.show_chart,
                        //      size: 16),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                      Text('Sell',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: cryptoController.showCryptoWithdrawal != true ? AppColors.textColor:
                                AppColors.whiteColor
                            ),
                          )),
                      Gap(5),
                      cryptoController.showCryptoWithdrawal != true ? Container() :
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.mainColor
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),

          Gap(30),

        ],
      ),
    );
  }

  // Step 2 - Enter Deposit Amount
  Widget sell() {
    return Padding(
      padding: EdgeInsets.all(16),
      // child:


    );
  }






}
