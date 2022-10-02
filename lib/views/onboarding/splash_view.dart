import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/splash_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<SplashViewModel>(
      onModelReady: (SplashViewModel model) => model.isLoggedIn(),
      builder: (_, __, ___) => Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: regularSansText(
            context,
            text: AppCache?.myChurch?.name ?? 'IntaChurch',
            color: AppColors.white,
            textAlign: TextAlign.center,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
