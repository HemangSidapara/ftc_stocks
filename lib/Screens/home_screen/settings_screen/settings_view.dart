import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with AutomaticKeepAliveClientMixin {
  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Header
          CustomHeaderWidget(
            title: AppStrings.settings.tr,
            titleIcon: AppAssets.settingsAnim,
            titleIconSize: 7.w,
          ),
          SizedBox(height: 5.h),

          ///Change Language
          ExpansionTile(
            controller: settingsController.expansionTileController,
            title: Text(
              AppStrings.changeLanguage.tr,
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
            backgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            childrenPadding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            children: [
              Divider(
                color: AppColors.PRIMARY_COLOR,
                thickness: 1,
              ),
              SizedBox(height: 1.h),
              Obx(() {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50.w, minHeight: 0.w, maxWidth: 90.w, minWidth: 90.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 5.w,
                    childAspectRatio: 3,
                    children: [
                      ///Gujarati
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'gu');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'gu', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(true);
                          settingsController.isHindiLang(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isGujaratiLang.isTrue ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.gujarati.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///English
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'en');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'en', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(false);
                          settingsController.isHindiLang(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isGujaratiLang.isFalse && settingsController.isHindiLang.isFalse ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.english.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///Hindi
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'hi');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'hi', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(false);
                          settingsController.isHindiLang(true);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isHindiLang.isTrue ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.hindi.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
          const Spacer(),

          ///LogOut
          ButtonWidget(
            onPressed: () {
              clearData();
              Get.offAllNamed(Routes.signInScreen);
            },
            buttonTitle: AppStrings.logOut.tr,
            fixedSize: Size(double.maxFinite, 5.h),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
