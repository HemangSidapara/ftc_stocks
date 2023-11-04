import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Constants/app_images.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/password_screen/password_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/background_widget.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';

class PasswordView extends StatefulWidget {
  const PasswordView({super.key});

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  PasswordController controller = Get.find<PasswordController>();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h).copyWith(bottom: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ///Heading
            Text(
              AppStrings.password.tr,
              style: TextStyle(
                color: AppColors.SECONDARY_COLOR,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),

            ///Password Image
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.otpImage,
                      height: 30.h,
                    ),
                    SizedBox(height: 7.5.h),

                    ///Password Field
                    Obx(() {
                      return Form(
                        key: controller.passwordFormKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom != 0 ? 2.h : 0),
                          child: TextFieldWidget(
                            controller: controller.passwordController,
                            title: AppStrings.password.tr,
                            hintText: AppStrings.enterPassword.tr,
                            validator: (value) {
                              return controller.validatePassword(value!);
                            },
                            obscureText: !controller.isShowPassword.value,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isShowPassword.toggle();
                              },
                              icon: Icon(
                                !controller.isShowPassword.value ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: AppColors.PRIMARY_COLOR,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            ///Submit
            ButtonWidget(
              onPressed: () async {
                await controller.checkPassword();
              },
              buttonTitle: AppStrings.login.tr,
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
