import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_no_virtual_card_body.dart';
import 'package:mkrempire/resources/widgets/custom_virtual_card_design.dart';
import 'package:get/get.dart';

class VirtualCardScreen extends StatefulWidget {
  const VirtualCardScreen({super.key});

  @override
  State<VirtualCardScreen> createState() => _VirtualCardScreenState();
}

class _VirtualCardScreenState extends State<VirtualCardScreen> {
  int _currentPage = 0;

  // Update the current page
  void _updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    HiveHelper.write(Keys.onBoarded, true);
    return GetBuilder<AppController>(builder: (appController) {
      return Scaffold(
        appBar: const CustomAppBar(
          // title: 'Patrick',
          isHomeScreen: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            CustomVirtualCardDesign(
              currentPage: _currentPage,
              onPageChanged: _updateCurrentPage, // Add page change callback
            ),
            const SizedBox(height: 22),
            CustomNoVirtualCardBody(
              appController,
              currentPage: _currentPage, // Pass the current page
            ),
          ],
        ),
      );
    });
  }
}
