import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/custom_textfield.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/size_config/config.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _riderLoginKey = GlobalKey<FormState>();
  bool formValid = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(
        onModelReady: (AuthViewModel m) => AppCache.haveFirstView(false),
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
                            text: 'Enter your Email',
                            color: AppColors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomTextField(
                            readOnly: model.busy,
                            hintText: 'Email address',
                            validator: Utils.validateEmail,
                            obscureText: false,
                            textInputType: TextInputType.emailAddress,
                            controller: emailController,
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
                              text: 'Reset Password',
                              fontSize: 14.sp,
                              textColor: AppColors.white,
                              buttonColor: AppColors.primaryColor,
                              borderColor: AppColors.primaryColor,
                              busy: model.busy,
                              function: formValid && !model.busy
                                  ? () {
                                      if (!_riderLoginKey.currentState
                                          .validate()) {
                                        _riderLoginKey.currentState.validate();
                                        setState(() {});
                                        return;
                                      }
                                      Utils.unfocusKeyboard(context);

                                      model.resetPassword(emailController.text);
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
