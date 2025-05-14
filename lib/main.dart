import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/helpers/init_hive.dart';
import 'package:mkrempire/config/app_contants.dart';
import 'package:mkrempire/config/app_themes.dart';
import 'package:mkrempire/routes/route_helper.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/bindings/init_binding.dart';

import 'app/helpers/hive_helper.dart';
import 'app/helpers/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initHive(),
    Future.delayed(const Duration(milliseconds: 4)),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      HiveHelper.write('lastActiveTime', DateTime.now().toIso8601String());
    } else if (state == AppLifecycleState.resumed) {
      _checkTokenExpiration();
    }
  }

  Future<void> _checkTokenExpiration() async {
    String? storedTime = await HiveHelper.read('lastActiveTime');
    String? token = HiveHelper.read(Keys.token);

    if (storedTime != null && token != null) {
      DateTime lastActive = DateTime.parse(storedTime);
      if (DateTime.now().difference(lastActive).inMinutes >= 3) {
        //handle user app lost focus timeout

        // HiveHelper.showSnackBar(msg: "Your session has timed out!");
        HiveHelper.remove(Keys.token);
        Get.offNamedUntil(
            RoutesName.loginScreen,
                (route) =>
            (route as GetPageRoute).routeName == RoutesName.loginScreen);
        // Get.dialog(Timeout());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            initialBinding: InitBindings(),
            themeMode: ThemeMode.light,
            initialRoute: RoutesName.initial,
            getPages: RouteHelper.routes(),
          );
        });
  }
}
