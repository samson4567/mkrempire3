import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/crypto_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
// import 'package:mkrempire/resources/screens/bottom_nav_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import '../../widgets/custom_pop_up.dart';
import '../others/bottom_nav_bar.dart';



class SellCrypto extends StatefulWidget {
  //

  final rate;
  final coin;
  final selectedCrypto;
  final amount;
  final chainType;
  const SellCrypto({super.key,required this.chainType,required this.coin, required this.rate,
    required this.amount,required this.selectedCrypto});
  @override
  State<SellCrypto> createState() => _SellCryptoState();
}

class _SellCryptoState extends State<SellCrypto> {
  PageController _pageController = PageController();
  CryptoController cryptoController =  Get.find<CryptoController>();
  int _currentStep = 1;
  String? selectedCrypto;
  final List<String> cryptoOptions = ["Bitcoin", "Ethereum", "USDT", "BNB"];
  TextEditingController amountController = TextEditingController();
  String? selectedNetwork;
  final Map<String, TextEditingController> _controllers = {};
  File? _selectedFile;
  final _formKey = GlobalKey<FormState>();
  // bool isfileS

  void showCryptoBottomSheet() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.black,
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
                          // color: AppColors.darkBgColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        title: Text("${crypto['coin']}", style: TextStyle(color:  AppColors.textColor)),
                        onTap: () async {
                          setState(() {
                            cryptoController.tradeResponse['message']['bybit']['coin'] = crypto['coin'];
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
    // if (cryptoController.tradeResponse['message']['bybit']['coin'] == null || !cryptoNetworks.containsKey(cryptoController.tradeResponse['message']['bybit']['coin'])) return;

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
                      // color: AppColors.darkBgColor,
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
                      await cryptoController.deposit(cryptoController.tradeResponse['message']['bybit']['coin']!,network.chain);
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


  @override
  void dispose() {
    // Dispose controllers
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _submitForm() async {
    print('Form submitted with the following data:');

    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        CustomDialog.showWarning(context: context, message: 'Kindly upload file!', buttonText: 'Cancel');
        return;
      }

      // Check if the file exists
      final file = File(_selectedFile!.path);
      final fileExists = await file.exists();
      if (!fileExists) {
        print('File does not exist at the specified path.');
        CustomDialog.showWarning(context: context, message: 'File not found!', buttonText: 'Cancel');
        return;
      }

      // Check file type
      String fileExtension = file.path.split('.').last;
      if (!['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        print('Unsupported file type: $fileExtension');
        CustomDialog.showWarning(context: context, message: 'Unsupported file type!', buttonText: 'Cancel');
        return;
      }

      Map<String, dynamic> uploadData = {};

      // Loop through the parameters to build the upload data
      cryptoController.selectedGateway['parameters'].forEach((key, param) {
        if (_controllers.containsKey(param['field_name'])) {
          uploadData[key] = {
            'field_name': param['field_name'],
            'value': param['type'] == 'file' && _selectedFile != null
                ? _selectedFile!.path // Use the actual file path
                : _controllers[param['field_name']]!.text,
            'validation': param['validation'],
          };
        } else {
          print('Controller for ${param['field_name']} not found.');
        }
      });

      print('Data to upload: $uploadData');

      final walletResponse = await cryptoController.dashboard();
      Map<String, dynamic> body = {
        'amount': '${widget.amount}',
        'gateway_id': '${cryptoController.selectedGateway['id']}',
        'supported_currency': '${widget.coin}',
        'wallet_id': walletResponse['message']['wallets'][1]['id'],
        'information': '${ jsonEncode(uploadData)}',
      };
      print(body);

      final response = await cryptoController.paymentRequest(body);
      if(response['status'] == 'success') {
        final trx_id = response['message']['trx_id'];
        final confirmPayment = await cryptoController.manualPayment(
            body, trx_id);

        if(response['status'] == 'success') {
          CustomDialog.showSuccess(context: context,
              message: '${confirmPayment['message']}',
              buttonText: 'Home',
              buttonAction: () => Get.to(BottomNavBar())
          );
        }else{
          CustomDialog.showWarning(context: context,
              message: '${confirmPayment['message']}',
              buttonText: 'Back',
              // buttonAction: () => Get.to(BottomNavBar())
          );
        }
        print(confirmPayment);
      }else{
        CustomDialog.showWarning(context: context,
            message: '${response['message']}',
            buttonText: 'Back',
            // buttonAction: () => Get.to(BottomNavBar())
        );
      }
      print(response);
    }
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
        icon: Icon(Icons.arrow_back_ios),
        onPressed: previousStep,
      ),
      title: Text(
        'Sell order',
        style: GoogleFonts.openSans(
          textStyle: TextStyle(fontSize: 13),
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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      // await cryptoController.getMasterDepositAddress(widget.coin);
      // cryptoController.tradeResponse['message']['bybit']['coin'] = cryptoController.ethData['FROMSYMBOL'];
      // Add Your Code here.
      cryptoController.amountController = TextEditingController();
      cryptoController.addressController = TextEditingController();;
      // Initialize controllers for each parameter
      cryptoController.selectedGateway['parameters'].forEach((key, value) {
        _controllers[key] = TextEditingController();
      });

    });
  }
  Future<void> _refresh() async{
    _init();
  }

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    print(cryptoController.selectedGateway);
    print(widget.selectedCrypto);
    cryptoController.context = context;
    return Scaffold(
        appBar: CustomizedAppBar(),
        body: RefreshIndicator(
          onRefresh: _refresh, // Define this function to refresh data
          child:SafeArea(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("Buy",
                      //     style: TextStyle(color: Colors.white,fontSize: 30)),
                      Gap(30),
                      // Ethereum Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withAlpha(22),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Coin', style: GoogleFonts.tsukimiRounded(
                                    textStyle: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)
                                ),),
                                Text('${widget.coin}',style: GoogleFonts.tsukimiRounded(
                                    textStyle: TextStyle(fontSize: 16)
                                ),)
                              ],
                            ),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rate', style: GoogleFonts.tsukimiRounded(
                                    textStyle: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)
                                ),),
                                Text(NumberFormat('#,##0.00').format(double.parse(widget.rate)),style: GoogleFonts.tsukimiRounded(
                                    textStyle: const TextStyle(fontSize: 16)
                                ),)
                              ],
                            ),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Value', style: GoogleFonts.tsukimiRounded(
                                    textStyle: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)
                                ),),
                                Text("NGN"+NumberFormat('#,##0.00').format(double.parse('${widget.amount}') * double.parse('${widget.rate}')),style: GoogleFonts.tsukimiRounded(
                                    textStyle: TextStyle(fontSize: 16)
                                ),)
                              ],
                            ),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Amount to pay', style: GoogleFonts.tsukimiRounded(
                                    textStyle: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)
                                ),),
                                Text("${widget.amount}",style: GoogleFonts.tsukimiRounded(
                                    textStyle: TextStyle(fontSize: 16)
                                ),)
                              ],
                            ),
                            // Text('${cryptoController.selectedGateway['description']}')
                          ],
                        ),
                      ),

                      Gap(30),
                      // Ethereum Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withAlpha(22),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        child: Column(
                          children: [
                            Html(
                              data: '${cryptoController.selectedGateway['description']}',
                            ),

                            Center(
                              child: QrImageView(
                                data: '${widget.selectedCrypto['wallet_address']}',
                                version: QrVersions.auto,
                                size: 250.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    '${widget.selectedCrypto['wallet_address']}',
                                    style: TextStyle(fontSize: 16,color:  AppColors.mainColor,),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print('${widget.selectedCrypto}');
                                    // if (cryptoController.depositAddressModel.addressDeposit != null) {
                                      Clipboard.setData(ClipboardData(text: '${widget.selectedCrypto['wallet_address']}'));
                                      showAnimatedPopup(context, "Copied to clipboard");
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      // SnackBar(content: Text("Copied to clipboard")),
                                      // );
                                    // }
                                  },
                                  icon: Icon(Icons.copy, color: AppColors.mainColor),
                                ),
                              ],
                            ),
                            // Text('${cryptoController.selectedGateway['description']}')
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),


                      Gap(30),
                      // cryptoStepOne()
                    Obx((){
                      return   CustomAppButton(
                        // onTap: (){nextStep();},
                        isLoading: cryptoController.isLoading.value  == true,
                        onTap: () async{
                          final walletResponse = await cryptoController.dashboard();
                          Map<String,dynamic> body = {
                            'amount' : '${widget.amount}',
                            'gateway_id' : '${cryptoController.selectedGateway['id']}',
                            'supported_currency':  '${widget.coin}',
                            'wallet_id' : walletResponse['message']['wallets'][1]['id'],
                            'information' : '',
                          };
                          print(body);
                          CustomDialog.showSuccess(
                            context: context,
                            message: 'Transaction is procesing',
                            buttonText: 'Home',buttonAction: ()=>Get.to(()=>BottomNavBar()),
                          );
                          //   final response = await cryptoController.paymentRequest(body);
                          //
                          //   CustomDialog.showWarning(context: context, message: '${response['message']}', buttonText: 'buttonText');
                          //   print(response);
                        },
                        text: 'I have made the payment',
                      );
                    })


                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                        key: _formKey, // Ensure the Form widget is here
                        child: Column(
                          children: [

                            // SizedBox(height: 6),
                            const Text("Confirm Transaction",
                                style: TextStyle(color: Colors.white,fontSize: 25)),
                            // Gap(Gap)
                            SizedBox(height: 10),
                            // Loop through parameters and create input fields
                            ...cryptoController.selectedGateway['parameters'].entries.map((entry) {
                              final param = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(param['field_label']),
                                    SizedBox(height: 4),
                                    if (param['type'] == 'text')
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.greyColor.withAlpha(72)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child:TextFormField(
                                          controller: _controllers[param['field_name']],
                                          decoration: InputDecoration(
                                            hintText: param['field_label'],
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter ${param['field_label']}';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    if (param['type'] == 'file')
                                      CustomAppButton(
                                        onTap: _pickFile,
                                        bgColor: AppColors.secondaryColor,
                                        text: '${param['field_label']}',
                                      ),
                                    // if (_selectedFile != null && param['type'] == 'file')
                                    //   Text('Selected file: ${_selectedFile!.path.split('/').last}'),
                                  ],
                                ),
                              );
                            }).toList(),
                            if (_selectedFile != null)
                              Center(
                                // padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text('Selected file: ${_selectedFile!.path.split('/').last}'),
                                    SizedBox(height: 8),
                                    // Preview the selected image
                                    Image.file(
                                      _selectedFile!,
                                      height: MediaQuery.of(context).size.height * 0.4, // Set the height of the image
                                      width: MediaQuery.of(context).size.width, // Set the width of the image
                                      fit: BoxFit.cover, // Adjust the image fit
                                    ),
                                  ],
                                ),
                              ),


                            const Spacer(),
                            Obx(() {
                              return CustomAppButton(
                                bgColor:  AppColors.mainColor,
                                isLoading: cryptoController.isLoading.value == true,
                                onTap:_submitForm,
                                //   final response = await cryptoController.placeOrder("${cryptoController.tradeResponse['message']['bybit']['coin']}USDT", cryptoController.amountController.text, 'Buy');
                                //   CustomDialog.showError(context: context, message: 'Limit exceeded or not reached!', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
                                // },
                                text: 'Continue',
                              );
                            }),
                          ],
                        ))),
              ],
            ),
          ),
          // backgroundColor: Colors.black,
        ));
  }

}
