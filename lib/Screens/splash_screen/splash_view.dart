import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Screens/splash_screen/splash_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.PRIMARY_COLOR,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_COLOR,
      body: Container(
        alignment: Alignment.center,
        color: AppColors.PRIMARY_BACK_COLOR,
        child: Column(
          children: [
            Container(
              height: 20.h,
              width: 20.h,
              color: AppColors.PRIMARY_COLOR,
            ),
          ],
        ),
      ),
    );
  }
}
