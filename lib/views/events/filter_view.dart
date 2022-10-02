import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/events/widgets/filter_textfield.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/size_config/config.dart';


class FilterView extends StatefulWidget {
  const FilterView({Key key}) : super(key: key);

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  bool lessThan2 = false, equals2 = false, greaterThan2 = false;

  double sliderValue = 30;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: Utils.offKeyboard,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.h)),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.all(20.h),
              child: regularSansText(context,
                  text: 'HOURS',
                  fontSize: 16.sp,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  regularSansText(context,
                      text: '15 mins',
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w400),
                  regularSansText(context,
                      text: 'Value: ${(15 + sliderValue).toInt()} mins',
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w400),
                ],
              ),
            ),
            Slider(
                value: sliderValue,
                onChanged: (a) {
                  sliderValue = a;
                  setState(() {});
                },
                min: 0,
                label: '$sliderValue',
                max: 100,
                activeColor: AppColors.primaryColor),
            FilterTextField(
              hintText: 'Type it here...',
            ),
            Padding(
              padding: EdgeInsets.all(20.h),
              child: regularSansText(context,
                  text: 'Type',
                  fontSize: 16.sp,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Checkbox(
                    value: lessThan2,
                    onChanged: (a) {
                      lessThan2 = !lessThan2;
                      setState(() {});
                    },
                    checkColor: AppColors.white,
                    activeColor: AppColors.primaryColor,
                  ),
                  regularSansText(context,
                      text: 'Less than 2 hours',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Checkbox(
                    value: equals2,
                    onChanged: (a) {
                      equals2 = !equals2;
                      setState(() {});
                    },
                    checkColor: AppColors.white,
                    activeColor: AppColors.primaryColor,
                  ),
                  regularSansText(context,
                      text: '2 hours',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Checkbox(
                    value: greaterThan2,
                    onChanged: (a) {
                      greaterThan2 = !greaterThan2;
                      setState(() {});
                    },
                    checkColor: AppColors.white,
                    activeColor: AppColors.primaryColor,
                  ),
                  regularSansText(context,
                      text: 'Above 2 hours',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Discard',
                        fontSize: 14.sp,
                        textColor: AppColors.textGrey,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.textGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Apply Filters',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
