import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/auth/forgot_password_view.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/custom_textfield.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../app/size_config/config.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  final GlobalKey<FormState> _riderLoginKey = GlobalKey<FormState>();
  bool formValid = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final provider = Provider.of<AuthViewModel>(context, listen: false);

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
                            text: 'Change password',
                            color: AppColors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomTextField(
                            readOnly: model.busy,
                            textInputType: TextInputType.text,
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            textAlign: TextAlign.start,
                            hintText: 'New Password',
                            validator: Utils.isValidPassword,
                            onChanged: (a) {
                              formValid =
                                  _riderLoginKey.currentState.validate();
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomTextField(
                            readOnly: model.busy,
                            textInputType: TextInputType.text,
                            controller: cPasswordController,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            textAlign: TextAlign.start,
                            hintText: 'Confirm New Password',
                            validator: (a) {
                              if (a != passwordController.text) {
                                return 'Password does not match';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (a) {
                              formValid =
                                  _riderLoginKey.currentState.validate();
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: buttonWithBorder(context,
                              text: 'Log in',
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
                                      model.changePassword(provider.otp,
                                          passwordController.text);
                                    }
                                  : null),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            routeTo(context, ForgotPasswordView());
                          },
                          child: Center(
                            child: regularSansText(
                              context,
                              text: 'Forgot Password?',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey,
                            ),
                          ),
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
