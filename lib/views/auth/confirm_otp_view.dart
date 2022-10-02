import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/custom_textfield.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../app/size_config/config.dart';

class ConfirmOtpView extends StatefulWidget {
  const ConfirmOtpView({Key key}) : super(key: key);

  @override
  _ConfirmOtpViewState createState() => _ConfirmOtpViewState();
}

class _ConfirmOtpViewState extends State<ConfirmOtpView> {
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _riderLoginKey = GlobalKey<FormState>();
  bool formValid = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(
        builder: (_, AuthViewModel model, __) => GestureDetector(
              onTap: Utils.offKeyboard,
              child: Form(
                key: _riderLoginKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: SizeConfig.screenHeight / 2.6,
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: AppColors.primaryColor),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20.w),
                          child: regularSansText(
                            context,
                            text: 'Church App',
                            color: AppColors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: regularSansText(
                            context,
                            text: 'Enter the OTP sent to your mail',
                            color: AppColors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomTextField(
                            hintText: 'OTP',
                            readOnly: false,
                            validator: Utils.isValidName,
                            textInputType: TextInputType.number,
                            controller: otpController,
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            onChanged: (a) {
                              formValid =
                                  _riderLoginKey.currentState.validate();
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: buttonWithBorder(context,
                              text: 'Confirm OTP',
                              fontSize: 14.sp,
                              textColor: AppColors.white,
                              buttonColor: AppColors.primaryColor,
                              borderColor: AppColors.primaryColor,
                              function: formValid
                                  ? () {
                                      if (!_riderLoginKey.currentState
                                          .validate()) {
                                        _riderLoginKey.currentState.validate();
                                        setState(() {});
                                        return;
                                      }
                                      Utils.unfocusKeyboard(context);
                                      context
                                          .read<AuthViewModel>()
                                    .setOTP(otpController.text);

                                model.confirmOtp();
                              }
                                  : null),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
