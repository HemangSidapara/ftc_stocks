import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({super.key});

  @override
  State<PendingOrdersView> createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  PendingOrdersController pendingOrdersController = Get.find<PendingOrdersController>();

  @override
  void initState() {
    super.initState();
    pendingOrdersController.searchPendingOrdersController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      child: Column(
        children: [
          ///Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHeaderWidget(
                title: AppStrings.pendingOrders.tr,
                titleIcon: AppAssets.pendingOrderIcon,
                onBackPressed: () {
                  if (Get.keys[0]?.currentState?.canPop() == true) {
                    Get.back(id: 0, closeOverlays: true);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: IconButton(
                  onPressed: pendingOrdersController.isRefreshing.value
                      ? () {}
                      : () async {
                          await pendingOrdersController.getOrdersApiCall(isLoading: false);
                        },
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Obx(() {
                    return TweenAnimationBuilder(
                      duration: Duration(seconds: pendingOrdersController.isRefreshing.value ? 45 : 1),
                      tween: Tween(begin: 0.0, end: pendingOrdersController.isRefreshing.value ? 45.0 : pendingOrdersController.ceilValueForRefresh.value),
                      onEnd: () {
                        pendingOrdersController.isRefreshing.value = false;
                      },
                      builder: (context, value, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          pendingOrdersController.ceilValueForRefresh(value.toDouble().ceilToDouble());
                        });
                        return Transform.rotate(
                          angle: value * 2 * 3.141592653589793,
                          child: Icon(
                            Icons.refresh_rounded,
                            color: AppColors.SECONDARY_COLOR,
                            size: 6.w,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          ///Search bar
          TextFieldWidget(
            controller: pendingOrdersController.searchPendingOrdersController,
            hintText: AppStrings.searchPendingOrders.tr,
            suffixIcon: pendingOrdersController.searchPendingOrdersController.text.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      pendingOrdersController.searchPendingOrdersController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      await getSearchedOrderList(searchedValue: pendingOrdersController.searchPendingOrdersController.text);
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.SECONDARY_COLOR,
                      size: context.isPortrait ? 4.w : 4.h,
                    ),
                  )
                : null,
            suffixIconConstraints: BoxConstraints(minWidth: context.isPortrait ? 10.w : 10.h, maxWidth: context.isPortrait ? 10.w : 10.h),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.SECONDARY_COLOR,
              size: context.isPortrait ? 4.w : 4.h,
            ),
            prefixIconConstraints: BoxConstraints(minWidth: context.isPortrait ? 10.w : 10.h, maxWidth: context.isPortrait ? 10.w : 10.h),
            onChanged: (value) async {
              await getSearchedOrderList(searchedValue: value);
            },
          ),
          SizedBox(height: 1.h),

          ///Data
          Expanded(
            child: Obx(() {
              if (pendingOrdersController.isGetOrdersLoading.value) {
                return const LoadingWidget();
              } else if (pendingOrdersController.searchedOrderList.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noDataFound.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: pendingOrdersController.searchedOrderList.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Party Name
                          Row(
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              Text(
                                pendingOrdersController.searchedOrdersDataList[index].partyName ?? '',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),

                          ///Cancel
                          Obx(() {
                            return TextButton(
                              onPressed: pendingOrdersController.cancelId.value != '' || pendingOrdersController.doneId.value != ''
                                  ? null
                                  : () async {
                                      pendingOrdersController.cancelId.value = pendingOrdersController.searchedOrdersDataList[index].orderId ?? '';
                                      await pendingOrdersController.cancelOrderApiCall(orderId: pendingOrdersController.searchedOrdersDataList[index].orderId ?? '');
                                      pendingOrdersController.cancelId.value = '';
                                    },
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: pendingOrdersController.cancelId.value == pendingOrdersController.searchedOrdersDataList[index].orderId
                                  ? Center(
                                      child: SizedBox(
                                        height: 4.w,
                                        width: 4.w,
                                        child: CircularProgressIndicator(
                                          color: AppColors.PRIMARY_COLOR,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      AppStrings.cancel.tr,
                                      style: TextStyle(
                                        color: AppColors.ERROR_COLOR,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                      collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                      backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      childrenPadding: EdgeInsets.only(bottom: 2.h),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                  text: AppStrings.productName.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: pendingOrdersController.searchedOrderList[index],
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ( ${pendingOrdersController.searchedOrdersDataList[index].category?.tr} )',
                                      style: TextStyle(
                                        color: AppColors.ORANGE_COLOR,
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                          child: ListView.separated(
                            itemCount: pendingOrdersController.searchedOrdersDataList[index].modelMeta?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, innerIndex) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                                child: Column(
                                  children: [
                                    Text(
                                      '${AppStrings.size.tr} ${pendingOrdersController.searchedOrdersDataList[index].modelMeta?[innerIndex].size?.tr}',
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    Container(
                                      color: AppColors.PRIMARY_COLOR,
                                      child: SizedBox(
                                        height: 1.5,
                                        width: 15.w,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text.rich(
                                      TextSpan(
                                        text: AppStrings.quantity.tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.8,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: pendingOrdersController.searchedOrdersDataList[index].modelMeta?[innerIndex].piece ?? '0',
                                            style: TextStyle(
                                              color: AppColors.DARK_GREEN_COLOR,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\n${AppStrings.weight.tr}',
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: pendingOrdersController.searchedOrdersDataList[index].modelMeta?[innerIndex].weight ?? '0 kg',
                                                style: TextStyle(
                                                  color: AppColors.DARK_GREEN_COLOR,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return VerticalDivider(
                                thickness: 1,
                                color: AppColors.PRIMARY_COLOR,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 2.h);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Future<void> getSearchedOrderList({required String searchedValue}) async {
    pendingOrdersController.searchedOrdersDataList.clear();
    pendingOrdersController.searchedOrderList.clear();
    if (searchedValue != "") {
      pendingOrdersController.searchedOrdersDataList.addAll(pendingOrdersController.ordersDataList.where(
        (e) {
          return e.partyName?.contains(searchedValue) == true || e.partyName?.toLowerCase().contains(searchedValue) == true;
        },
      ).toList());
      pendingOrdersController.searchedOrderList.addAll(pendingOrdersController.searchedOrdersDataList.map((e) => e.name ?? '').toList());
    } else {
      pendingOrdersController.searchedOrdersDataList.addAll(pendingOrdersController.ordersDataList);
      pendingOrdersController.searchedOrderList.addAll(pendingOrdersController.orderList);
    }
  }
}
