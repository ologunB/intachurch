import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/auth/forgot_password_view.dart';
import 'package:mms_app/views/auth/signup_view.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/custom_textfield.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/size_config/config.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                  bottomNavigationBar: SafeArea(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.openSans(
                                fontSize: 14.w,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'Create one',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      routeTo(context, SignupView());
                                    },
                                ),
                              ]),
                        )),
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
                        text: 'IntaChurch',
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
                        text: 'Welcome back',
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomTextField(
                        readOnly: model.busy,
                        textInputType: TextInputType.text,
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        textAlign: TextAlign.start,
                        hintText: 'Password',
                        validator: Utils.isValidPassword,
                        onChanged: (a) {
                          formValid =
                              _riderLoginKey.currentState.validate();
                          setState(() {});
                        },
                        onSaved: (a) {
                          if (formValid && !model.busy) {
                            if (!_riderLoginKey.currentState.validate()) {
                              _riderLoginKey.currentState.validate();
                              setState(() {});
                              return;
                            }
                            Utils.unfocusKeyboard(context);
                            final Map<String, String> data =
                            <String, String>{
                              'email': emailController.text,
                              'password': passwordController.text,
                            };
                            model.login(data);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
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
                            final Map<String, String> data =
                            <String, String>{
                              'email': emailController.text,
                              'password': passwordController.text,
                            };
                            model.login(data);
                          }
                              : null),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
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
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
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
