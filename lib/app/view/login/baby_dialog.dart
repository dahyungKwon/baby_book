import 'package:baby_book/app/controller/BabyDialogController.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../base/color_data.dart';
import '../../models/model_baby.dart';
import 'birth_bottom_sheet.dart';
import 'gender_type.dart';
import 'gender_type_bottom_sheet.dart';

class BabyDialog extends GetView<BabyDialogController> {
  bool modifyMode = false;
  int? selectedBabyIndex;

  BabyDialog(this.selectedBabyIndex, ModelBaby? selectedBaby, String callerType, {Key? key}) : super(key: key) {
    Get.delete<BabyDialogController>();
    Get.put(BabyDialogController(babyRepository: BabyRepository(), callerType: callerType));

    if (selectedBaby == null) {
      modifyMode = false;
      controller.nameController.text = "";
      controller.gender = GenderType.none;
      controller.selectedModelBaby = selectedBaby;
    } else {
      modifyMode = true;
      controller.nameController.text = selectedBaby.name!;
      controller.gender = selectedBaby.gender;
      controller.selectedBirthday = selectedBaby.birth!;
      controller.selectedModelBaby = selectedBaby;
    }
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
        backgroundColor: backGroundColor,
        content: Builder(
          builder: (context) {
            return Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: getDefaultTextFiledWithLabel2(
                            context,
                            "아기 이름을 입력해주세요",
                            Colors.black45.withOpacity(0.3),
                            controller.nameController,
                            Colors.grey,
                            FetchPixels.getPixelHeight(15),
                            FontWeight.w400,
                            function: () {},
                            isEnable: false,
                            withprefix: false,
                            minLines: true,
                            autofocus: true,
                            height: FetchPixels.getPixelHeight(60),
                            alignmentGeometry: Alignment.center,
                            boxColor: Colors.white,
                          )),
                          getHorSpace(FetchPixels.getPixelHeight(5)),
                        ]),
                    // getVerSpace(FetchPixels.getPixelHeight(5)),
                    getDefaultTextFiledWithLabel2(
                        context,
                        controller.gender == GenderType.none ? "성별을 선택해주세요." : controller.gender.baby,
                        controller.gender == GenderType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
                        controller.genderController,
                        Colors.black87,
                        FetchPixels.getPixelHeight(15),
                        boxColor: backGroundColor,
                        FontWeight.w400, function: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => GenderTypeBottomSheet(
                              genderType: controller.gender!,
                              genderPresentationType: GenderTypeBottomSheet.genderBaby)).then((selectedGender) {
                        if (selectedGender != null) {
                          controller.changeGender(selectedGender);
                        }
                      });
                    },
                        isEnable: false,
                        withprefix: false,
                        minLines: true,
                        height: FetchPixels.getPixelHeight(60),
                        withSufix: true,
                        suffiximage: controller.gender == GenderType.none ? "down_arrow.svg" : "confirm_mark.svg",
                        enableEditing: false),
                    getDefaultTextFiledWithLabel2(
                        context,
                        controller.selectedBirthday == null
                            ? "생일을 입력해주세요."
                            : DateFormat('yyyy-MM-dd').format(controller.selectedBirthday!),
                        controller.selectedBirthday == null ? Colors.black45.withOpacity(0.3) : Colors.black,
                        controller.birthController,
                        Colors.black87,
                        FetchPixels.getPixelHeight(15),
                        boxColor: backGroundColor,
                        FontWeight.w400, function: () {
                      showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => BirthBottomSheet(birth: controller.selectedBirthday))
                          .then((selectedDate) async {
                        if (selectedDate != null) {
                          // controller.changeGender(selectedGender);
                          print("good $selectedDate");
                          controller.selectedBirthday = selectedDate;
                        }
                      });
                    },
                        isEnable: false,
                        withprefix: false,
                        minLines: true,
                        height: FetchPixels.getPixelHeight(60),
                        withSufix: true,
                        suffiximage: controller.selectedBirthday == null ? "birth_calendar.svg" : "confirm_mark.svg",
                        enableEditing: false),
                    getVerSpace(FetchPixels.getPixelHeight(30)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getButton(context, Colors.transparent, "취소", Colors.black, () {
                            Get.back();
                          }, 15,
                              weight: FontWeight.w500,
                              buttonWidth: FetchPixels.getPixelHeight(60),
                              buttonHeight: FetchPixels.getPixelHeight(40),
                              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8))),
                          getHorSpace(FetchPixels.getPixelHeight(20)),
                          getButton(context, Colors.transparent, "완료", Colors.black, () {
                            controller.confirm(selectedBabyIndex, modifyMode);
                          }, 15,
                              weight: FontWeight.w500,
                              buttonWidth: FetchPixels.getPixelHeight(60),
                              buttonHeight: FetchPixels.getPixelHeight(40),
                              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)))
                        ])
                  ],
                ));
          },
        ),
      ),
    );
  }
}
