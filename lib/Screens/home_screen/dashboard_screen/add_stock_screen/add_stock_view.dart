// ignore_for_file: non_constant_identifier_names
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_controller.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/dropdown_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';

class AddStockView extends StatefulWidget {
  const AddStockView({super.key});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  AddStockController addStockController = Get.find<AddStockController>();

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return Obx(() {
      return CustomScaffoldWidget(
        isPadded: true,
        bottomSheet: addStockController.isGetStockLoading.value
            ? null
            : ButtonWidget(
                onPressed: addStockController.isAddStockLoading.value
                    ? () {}
                    : () async {
                        await addStockController.checkAddStock();
                      },
                isLoading: addStockController.isAddStockLoading.value,
                fixedSize: Size(double.maxFinite, 5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 5.w,
                      color: AppColors.WHITE_COLOR,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      AppStrings.add.tr,
                      style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Header
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (Get.keys[0]?.currentState?.canPop() == true) {
                      Get.back(id: 0);
                    }
                  },
                  style: IconButton.styleFrom(
                    surfaceTintColor: AppColors.LIGHT_SECONDARY_COLOR,
                    highlightColor: AppColors.LIGHT_SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Image.asset(
                    AppAssets.backIcon,
                    width: 8.w,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  AppStrings.addStock.tr,
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 2.w),
                Image.asset(
                  AppAssets.addStockIcon,
                  width: 8.w,
                ),
              ],
            ),
            SizedBox(height: 2.h),

            ///Fields
            Expanded(
              child: Obx(() {
                if (addStockController.isGetStockLoading.value) {
                  return const LoadingWidget();
                } else {
                  return SingleChildScrollView(
                    child: Form(
                      key: addStockController.addStockFormKey,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? 2.h : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Product
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Text(
                                AppStrings.product.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DropdownSearch<String>(
                              onChanged: (value) {
                                if (value != null) {
                                  addStockController.selectedProduct.value = addStockController.productList.indexOf(value);
                                  addStockController.productNameController.clear();
                                  addStockController.selectedCategory.value = addStockController.categoryList.indexOf(addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.category ?? '');
                                  addStockController.selectedSizeList.clear();
                                  addStockController.selectedSizeList.addAll(addStockController.sizeList.where((element) => addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.modelMeta?.map((e) => e.size).toList().contains(element) == true).toList());
                                  addStockController.resetSizeControllers();

                                  for (int i = 0; i < addStockController.selectedSizeList.length; i++) {
                                    get_stock.ModelMeta? tempSizeData = addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.modelMeta?.where((e) => e.size == addStockController.selectedSizeList[i]).toList().firstOrNull;
                                    switch (addStockController.selectedSizeList[i]) {
                                      case '3':
                                        addStockController.sizeThreeWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeThreeUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeThreeQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeThreeWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      case '4':
                                        addStockController.sizeFourWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeFourUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeFourQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeFourWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      case '6':
                                        addStockController.sizeSixWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeSixUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeSixQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeSixWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      case '8':
                                        addStockController.sizeEightWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeEightUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeEightQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeEightWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      case '10':
                                        addStockController.sizeTenWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeTenUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeTenQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeTenWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      case '12':
                                        addStockController.sizeTwelveWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeTwelveUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeTwelveQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeTwelveWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                      default:
                                        addStockController.sizeCustomWeightOfPieceController.text = tempSizeData?.weightOfPiece?.replaceAll(' gm', '').replaceAll(' kg', '').trim() ?? '';
                                        addStockController.selectedSizeCustomUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.stockedSizeCustomQuantityController.text = tempSizeData?.piece?.trim() ?? '';
                                        addStockController.stockedSizeCustomWeightController.text = tempSizeData?.weight?.replaceAll(' kg', '').trim() ?? '';
                                    }
                                  }
                                }
                              },
                              dropdownButtonProps: DropdownButtonProps(
                                constraints: BoxConstraints.loose(Size(7.w, 4.5.h)),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 5.w,
                                ),
                              ),
                              validator: addStockController.validateProduct,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectProduct.tr,
                                  hintStyle: TextStyle(
                                    color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  errorStyle: TextStyle(
                                    color: AppColors.ERROR_COLOR,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.3.h).copyWith(right: 1.w),
                                ),
                              ),
                              items: addStockController.productList,
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                emptyBuilder: (context, searchEntry) {
                                  return Center(
                                    child: Text(
                                      AppStrings.noDataFound.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isSelected) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    child: Text(
                                      item.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.PRIMARY_COLOR,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchProduct.tr,
                                    hintStyle: TextStyle(
                                      color: AppColors.HINT_GREY_COLOR,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                                  ),
                                ),
                              ),
                            ),
                            TextFieldWidget(
                              controller: addStockController.productNameController,
                              hintText: AppStrings.enterProductName.tr,
                              isDisable: addStockController.selectedProduct.value != -1,
                            ),
                            SizedBox(height: 2.h),

                            ///Category
                            DropDownWidget(
                              value: addStockController.selectedCategory.value == -1 ? null : addStockController.selectedCategory.value,
                              title: AppStrings.category.tr,
                              hintText: AppStrings.selectCategory.tr,
                              selectedItemBuilder: (context) {
                                return [
                                  for (int i = 0; i < addStockController.categoryList.length; i++)
                                    Text(
                                      addStockController.categoryList[i].tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ];
                              },
                              items: [
                                for (int i = 0; i < addStockController.categoryList.length; i++)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text(
                                      addStockController.categoryList[i].tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                              ],
                              validator: addStockController.validateCategory,
                              onChanged: (value) {
                                addStockController.selectedCategory.value = value ?? -1;
                              },
                            ),
                            SizedBox(height: 2.h),

                            ///Product Size
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Text(
                                AppStrings.size.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 0.6.h),
                            DropdownSearch.multiSelection(
                              dropdownButtonProps: DropdownButtonProps(
                                constraints: BoxConstraints.loose(
                                  Size(7.w, 4.5.h),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 5.w,
                                ),
                              ),
                              validator: (value) {
                                return addStockController.validateProductSize(value!.toList());
                              },
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectSize.tr,
                                  hintStyle: TextStyle(
                                    color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  errorStyle: TextStyle(
                                    color: AppColors.ERROR_COLOR,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.3.h).copyWith(right: 1.w),
                                ),
                              ),
                              items: addStockController.sizeList,
                              popupProps: PopupPropsMultiSelection.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                validationWidgetBuilder: (context, item) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8),
                                    child: ButtonWidget(
                                      fixedSize: Size(double.maxFinite, 5.h),
                                      onPressed: () {
                                        setState(() {
                                          addStockController.selectedSizeList.clear();
                                          addStockController.selectedSizeList.addAll(item.map((e) => e.toString()).toList());
                                          addStockController.customProductSizeController.clear();
                                          addStockController.stockedSizeCustomQuantityController.clear();
                                          addStockController.stockedSizeCustomWeightController.clear();
                                          addStockController.sizeCustomQuantityController.clear();
                                          addStockController.sizeCustomWeightController.clear();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      buttonTitle: AppStrings.select.tr,
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isSelected) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    child: Text(
                                      item.toString().tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.PRIMARY_COLOR,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchSize.tr,
                                    hintStyle: TextStyle(
                                      color: AppColors.HINT_GREY_COLOR,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                                  ),
                                ),
                                selectionWidget: (context, item, isSelected) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelected = !isSelected;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(1.5),
                                      margin: EdgeInsets.only(right: 4.w),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.PRIMARY_COLOR : AppColors.TRANSPARENT,
                                        border: Border.all(
                                          color: AppColors.PRIMARY_COLOR,
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: AppColors.WHITE_COLOR,
                                        size: 4.3.w,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              dropdownBuilder: (context, selectedItems) {
                                selectedItems.clear();
                                selectedItems.addAll(addStockController.selectedSizeList);
                                if (selectedItems.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 0.3.h),
                                    child: Text(
                                      AppStrings.selectSize.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      children: selectedItems.map(
                                        (value) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedItems.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
                                                    addStockController.selectedSizeList.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
                                                  });
                                                },
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 2.w, right: 3.w, top: 0.3.h, bottom: 0.3.h),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: AppColors.PRIMARY_COLOR,
                                                        ),
                                                        margin: EdgeInsets.only(right: 2.5.w),
                                                        child: Text(
                                                          value.toString().tr,
                                                          textAlign: TextAlign.end,
                                                          style: TextStyle(
                                                            color: AppColors.WHITE_COLOR,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 2.5,
                                                      right: 1.5.w,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: AppColors.WHITE_COLOR,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: AppColors.ERROR_COLOR.withOpacity(0.8),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          padding: const EdgeInsets.all(2),
                                                          child: Icon(
                                                            size: 2.w,
                                                            Icons.close,
                                                            color: AppColors.WHITE_COLOR,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  );
                                }
                              },
                              selectedItems: addStockController.selectedSizeList,
                            ),
                            TextFieldWidget(
                              controller: addStockController.customProductSizeController,
                              hintText: AppStrings.enterProductSize.tr,
                              isDisable: addStockController.selectedSizeList.isNotEmpty,
                            ),
                            SizedBox(height: 2.h),

                            ///Size 3
                            if (addStockController.selectedSizeList.contains('3'))
                              SizeOfTheStock(
                                title: AppStrings.size3QuantityWeight,
                                weightOfPieceController: addStockController.sizeThreeWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeThreeQuantityController,
                                stockedWeightController: addStockController.stockedSizeThreeWeightController,
                                quantityController: addStockController.sizeThreeQuantityController,
                                weightController: addStockController.sizeThreeWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeThreeUnitOfWeight,
                              ),

                            ///Size 4
                            if (addStockController.selectedSizeList.contains('4'))
                              SizeOfTheStock(
                                title: AppStrings.size4QuantityWeight,
                                weightOfPieceController: addStockController.sizeFourWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeFourQuantityController,
                                stockedWeightController: addStockController.stockedSizeFourWeightController,
                                quantityController: addStockController.sizeFourQuantityController,
                                weightController: addStockController.sizeFourWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeFourUnitOfWeight,
                              ),

                            ///Size 6
                            if (addStockController.selectedSizeList.contains('6'))
                              SizeOfTheStock(
                                title: AppStrings.size6QuantityWeight,
                                weightOfPieceController: addStockController.sizeSixWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeSixQuantityController,
                                stockedWeightController: addStockController.stockedSizeSixWeightController,
                                quantityController: addStockController.sizeSixQuantityController,
                                weightController: addStockController.sizeSixWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeSixUnitOfWeight,
                              ),

                            ///Size 8
                            if (addStockController.selectedSizeList.contains('8'))
                              SizeOfTheStock(
                                title: AppStrings.size8QuantityWeight,
                                weightOfPieceController: addStockController.sizeEightWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeEightQuantityController,
                                stockedWeightController: addStockController.stockedSizeEightWeightController,
                                quantityController: addStockController.sizeEightQuantityController,
                                weightController: addStockController.sizeEightWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeEightUnitOfWeight,
                              ),

                            ///Size 10
                            if (addStockController.selectedSizeList.contains('10'))
                              SizeOfTheStock(
                                title: AppStrings.size10QuantityWeight,
                                weightOfPieceController: addStockController.sizeTenWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeTenQuantityController,
                                stockedWeightController: addStockController.stockedSizeTenWeightController,
                                quantityController: addStockController.sizeTenQuantityController,
                                weightController: addStockController.sizeTenWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeTenUnitOfWeight,
                              ),

                            ///Size 12
                            if (addStockController.selectedSizeList.contains('12'))
                              SizeOfTheStock(
                                title: AppStrings.size12QuantityWeight,
                                weightOfPieceController: addStockController.sizeTwelveWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeTwelveQuantityController,
                                stockedWeightController: addStockController.stockedSizeTwelveWeightController,
                                quantityController: addStockController.sizeTwelveQuantityController,
                                weightController: addStockController.sizeTwelveWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeTwelveUnitOfWeight,
                              ),

                            ///Custom Size
                            if (addStockController.isAddedCustomSize.isTrue)
                              SizeOfTheStock(
                                title: AppStrings.sizeCustomQuantityWeight,
                                weightOfPieceController: addStockController.sizeCustomWeightOfPieceController,
                                stockedQuantityController: addStockController.stockedSizeCustomQuantityController,
                                stockedWeightController: addStockController.stockedSizeCustomWeightController,
                                quantityController: addStockController.sizeCustomQuantityController,
                                weightController: addStockController.sizeCustomWeightController,
                                selectedUnitOfWeight: addStockController.selectedSizeCustomUnitOfWeight,
                              ),
                            SizedBox(height: keyboardPadding != 0 ? 0 : 8.h),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget SizeOfTheStock({
    required String title,
    required TextEditingController weightOfPieceController,
    required TextEditingController stockedQuantityController,
    required TextEditingController stockedWeightController,
    required TextEditingController quantityController,
    required TextEditingController weightController,
    required RxInt selectedUnitOfWeight,
  }) {
    quantityController.addListener(() {
      setState(() {});
    });
    weightController.addListener(() {
      setState(() {});
    });
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Text(
              title.tr,
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 0.6.h),

          ///Total Quantity & Weight
          Text.rich(
            TextSpan(
              text: AppStrings.totalQuantity.tr,
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                height: 1.7,
              ),
              children: [
                ///Total Quantity
                TextSpan(
                  text: stockedQuantityController.text.trim(),
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: ' + ${quantityController.text.trim().isEmpty ? 0 : quantityController.text.trim()}',
                      style: TextStyle(
                        color: AppColors.WARNING_COLOR,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: ' = ${(stockedQuantityController.text.trim().toDouble() + (quantityController.text.trim().isEmpty ? 0 : quantityController.text.trim().toDouble())).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.SUCCESS_COLOR,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                ///Total Weight
                TextSpan(
                  text: '\n${AppStrings.totalWeight.tr}',
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text: stockedWeightController.text.trim(),
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: ' + ${weightController.text.trim().isEmpty ? 0 : weightController.text.trim()}',
                          style: TextStyle(
                            color: AppColors.WARNING_COLOR,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: ' = ${(stockedWeightController.text.trim().toDouble() + (weightController.text.trim().isEmpty ? 0 : weightController.text.trim().toDouble())).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.SUCCESS_COLOR,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 54.w,
                child: TextFieldWidget(
                  controller: weightOfPieceController,
                  hintText: AppStrings.enterWeightOfSinglePiece.tr,
                  validator: addStockController.validateWeight,
                  onChanged: (value) {
                    quantityController.clear();
                    weightController.clear();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 32.w,
                child: DropDownWidget(
                  value: selectedUnitOfWeight.value == -1 ? null : selectedUnitOfWeight.value,
                  hintText: AppStrings.selectUnitOfWeight.tr,
                  selectedItemBuilder: (context) {
                    return [
                      for (int i = 0; i < addStockController.weightUnitList.length; i++)
                        SizedBox(
                          width: 22.w,
                          child: Text(
                            addStockController.weightUnitList[i].tr,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ];
                  },
                  items: [
                    for (int i = 0; i < addStockController.weightUnitList.length; i++)
                      DropdownMenuItem(
                        value: i,
                        child: Text(
                          addStockController.weightUnitList[i].tr,
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                  validator: addStockController.validateWeightUnit,
                  onChanged: (value) {
                    if (selectedUnitOfWeight.value != value) {
                      quantityController.clear();
                      weightController.clear();
                    }
                    selectedUnitOfWeight.value = value ?? -1;
                  },
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1
                ? () {
                    Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                  }
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 43.w,
                  child: TextFieldWidget(
                    controller: quantityController,
                    hintText: AppStrings.enterQuantity.tr,
                    validator: (value) {
                      return addStockController.validateQuantity(value, quantityController);
                    },
                    isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                    onChanged: (value) {
                      addStockController.calculateWeightByQuantity(
                        value,
                        weightController,
                        quantityController,
                        weightOfPieceController,
                        selectedUnitOfWeight,
                      );
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 43.w,
                  child: TextFieldWidget(
                    controller: weightController,
                    hintText: AppStrings.enterWeight.tr,
                    validator: addStockController.validateWeight,
                    isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                    onChanged: (value) {
                      addStockController.calculateQuantityByWeight(
                        value,
                        quantityController,
                        weightController,
                        weightOfPieceController,
                        selectedUnitOfWeight,
                      );
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      );
    });
  }
}
