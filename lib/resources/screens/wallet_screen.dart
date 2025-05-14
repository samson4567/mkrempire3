import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
// import 'package:mkrempire/resources/screens/more_screen.dart';
// import 'package:mkrempire/resources/screens/notification_screen.dart';
import 'package:mkrempire/resources/widgets/custom_balance_card.dart';
import 'package:mkrempire/resources/widgets/custom_pop_up.dart';

// import 'history_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  CryptoController cryptoController = Get.find<CryptoController>();


  void showTransactionBottomSheet(BuildContext context, dynamic history) {
    print(history);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return   Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Container(
                height: 10,
                width: 5,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: AppColors.textColor,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coin', style: TextStyle(color: Colors.white)),
                  Text(
                      history['coin'], style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chain', style: TextStyle(color: Colors.white)),
                  Text(history['chain'] ?? "",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount', style: TextStyle(color: Colors.white)),
                  Text(history['amount'].toString(),
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transaction ID  ',
                      style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Text(
                      history['txID'] ?? "",
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: history['txID']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'Transaction ID copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status', style: TextStyle(color: Colors.white)),
                  Text(history['status'].toString(),
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('To Address', style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Text(
                      history['toAddress'] ?? "",
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: history['toAddress'] ?? ""));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'To Address copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Success At', style: TextStyle(color: Colors.white)),
                  Text(
                      history['successAt']  ==  null ? "" :DateFormat('yyyy-MM-dd – kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(history['successAt'].toString()))),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Confirmations', style: TextStyle(color: Colors.white)),
                  Text(history['confirmations'].toString() ?? "",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Block Hash  ', style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Text(
                      history['blockHash'] ?? "",
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: history['blockHash'] ?? ""));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'Block Hash copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              // Add more fields as necessary
            ],
          ),
        );
      },
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return   Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(16),
          child: ListView(
            children:[

              InkWell(
                onTap: (){
                  cryptoController.showWithdrawalHistory.value = true;
                  cryptoController.showDepositHistory.value = true;
                  Get.back();
                },
                child: Text("Show All"),
              ),
              Gap(20),
              InkWell(
                onTap: (){
                  cryptoController.showWithdrawalHistory.value = false;
                  cryptoController.showDepositHistory.value = true;
                  Get.back();
                },
                child: Text("Deposit"),
              ),
              Gap(20),
              InkWell(
                onTap: (){
                  cryptoController.showDepositHistory.value = false;
                  cryptoController.showWithdrawalHistory.value = true;
                  Get.back();
                },
                child: Text("Withdrawal"),
              ),
              Gap(20),
            ],
          ),
        );
      },
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

  Future<void> _init() async{
    cryptoController.showWithdrawalHistory.value = true;
    cryptoController.showDepositHistory.value = true;
    await cryptoController.getRecord();
    await cryptoController.getCryptoWithdrawalHistory();
    await cryptoController.getCryptoBalance("USDT,USDC,ETH,BTC,SOL");
  }

  Future<void> _refresh() async{
    _init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
        onRefresh: _refresh, // Define this function to refresh data
        child:ListView(
      children: [ Column(
        children: [
          Gap(10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(20),
              Text(
                'My Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Gap(15),
         Obx((){
           return  CustomBalanceCard(
             // account_balance:
             // cryptoController.coinBalance.value,
             // card_color: AppColors.darkBgColor,
           );
         }),
          Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction History',
                style: TextStyle(color: AppColors.textColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: InkWell(
                        onTap: () {
                          // Get.to(HistoryScreen());
                          // Implement your action when the icon is tapped
                        },
                        child: Image.asset(
                          'assets/images/setting.png',
                          height: 30,
                          width: 50,
                          color: Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: InkWell(
                        onTap: () {
                          showFilterBottomSheet(context);
                        },
                        child: Image.asset(
                          'assets/images/filter.png',
                          height: 30,
                          width: 30,
                          color: AppColors.tertiaryColor,
                        ),
                      )),
              

                ],
              ),
              
            ],
          ),
            Obx(() {
              if (cryptoController.isLoading.value) {
                return Container(
                  width: 20,
                  height: 40,
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                );
              }

              if (cryptoController.walletHistories.isEmpty && cryptoController.withdrawalHistories.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text('No transactions found'),
                  ),
                );
              }

              return Container(
                height: 500,
                child: ListView(
                  children: [
                    if (cryptoController.showDepositHistory.value) ...[
                      ...cryptoController.walletHistories.map((history) {
                        return _buildTransactionCard(context, history, true);
                      }).toList(),
                    ],
                    if (cryptoController.showWithdrawalHistory.value) ...[
                      ...cryptoController.withdrawalHistories.map((history) {
                        // ${HiveHelper.read(Keys.user)['account_id'] == history['fromMemberId']}
                        print("${HiveHelper.read(Keys.user)['account_id']} - ${history['fromMemberId']} - ${history['amount']}");
                        var isDeposit = HiveHelper.read(Keys.user)['account_id'] != history['fromMemberId'];
                        print(isDeposit);
                        return _buildTransactionCard(context, history, isDeposit);
                      }).toList(),
                    ],
                  ],
                ),
              );
            }),

        ],
      ),
    ])) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }


  Widget _buildTransactionCard(BuildContext context, Map<String, dynamic> history, bool isDeposit) {
    print('${isDeposit ? '+' : '-'}${history['amount']} ${history['coin']}');
    print(history['successAt'] == null ? history['timestamp'].toString() :
    history['successAt'].toString());
    return InkWell(
      onTap: () => showTransactionBottomSheet(context, history),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${history['coin']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${isDeposit ? '+' : '-'}${history['amount']} ${history['coin']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDeposit ? AppColors.greenColor : AppColors.redColor,
                  ),
                ),
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(
                              isDeposit ?
                              history['successAt'] == null ? history['timestamp'].toString() :
                              history['successAt'].toString() :
                              history['timestamp'].toString()))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
