import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/views/auth/change_password_view.dart';
import 'package:mms_app/views/auth/confirm_otp_view.dart';
import 'package:mms_app/views/auth/login_view.dart';
import 'package:mms_app/views/main_layout.dart';
import 'package:mms_app/views/onboarding/onboarding_view.dart';

const String OnboardingScreen = '/onboarding-view';
const String LoginScreen = '/login-view';
const String LayoutScreen = '/layout-view';
const String ChangePasswordScreen = '/change-password';
const String ConfirmOTPScreen = '/confirm-otp';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LayoutScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: MainLayout(),
        args: settings.arguments,
      );
    case LoginScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: LoginView(),
        args: settings.arguments,
      );
    case OnboardingScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: OnboardingView(),
        args: settings.arguments,
      );
    case ChangePasswordScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: ChangePasswordView(),
        args: settings.arguments,
      );
    case ConfirmOTPScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: ConfirmOtpView(),
        args: settings.arguments,
      );
    default:
      return CupertinoPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute<dynamic> _getPageRoute({String routeName, Widget view, Object args}) {
  return CupertinoPageRoute<dynamic>(
      settings: RouteSettings(name: routeName, arguments: args),
      builder: (_) => view);
}

void routeTo(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.push<void>(
      context,
      CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) => view, fullscreenDialog: dialog));
}

void routeToReplace(BuildContext context, Widget view) {
  Navigator.pushAndRemoveUntil<void>(
      context,
      CupertinoPageRoute<dynamic>(builder: (BuildContext context) => view),
      (Route<void> route) => false);
}
