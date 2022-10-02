import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/onboard_vm.dart';
import 'package:mms_app/views/onboarding/pages/page_one.dart';
import 'package:mms_app/views/onboarding/pages/page_three.dart';
import 'package:mms_app/views/onboarding/pages/page_two.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/image_widget.dart';
import 'package:mms_app/views/widgets/indicator.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/size_config/config.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<OnboardingViewModel>(
        builder: (_, OnboardingViewModel model, __) => Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Stack(
                    children: [
                      ImageWidget(image: Images.onboardBackground),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: SizeConfig.screenHeight / 2.2,
                          width: SizeConfig.screenWidth,
                          child: PageView(
                            controller: model.controller(),
                            onPageChanged: (index) => model.onChanged(index),
                            children: [
                              PageOne(),
                              PageTwo(),
                              PageThree(),
                            ],
                          ),
                        ),
                      ),
                      model.index == 0
                          ? Positioned(
                              bottom: 0.h,
                              right: 0,
                              left: 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenWidth / 10),
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1.h,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      model.index == 0
                          ? Positioned(
                              bottom: 1.h,
                              right: 80.w,
                              child: ImageWidget(
                                image: Images.onboardVec,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Expanded(child: SizedBox(height: 8.h)),
                  Indicator(
                    length: 3,
                    index: model.index,
                    height: 5.h,
                    width: 18.w,
                    active: AppColors.primaryColor,
                    inactive: AppColors.darkTextGrey.withOpacity(0.4),
                    radius: 6.h,
                    margin: 2.w,
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    width: SizeConfig.screenWidth / 1.2,
                    child: buttonWithBorder(
                      context,
                      fontSize: 14.sp,
                      text: model.index < 2 ? 'Next' : 'Get started',
                      textColor: AppColors.white,
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      function: () => model.index < 2
                          ? model.nextPage()
                          : model.navigateToLoginView(),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  model.index < 2
                      ? InkWell(
                          onTap: model.navigateToLoginView,
                          child: regularSansText(
                            context,
                            text: 'Skip to Log In',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey,
                          ),
                        )
                      : regularSansText(
                          context,
                          text: '',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey,
                        ),
                  Expanded(child: SafeArea(child: SizedBox(height: 30.h))),
                ],
              ),
            ));
  }
}
