import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';
import '../membership/widgets/member_option.dart';
import '../membership/widgets/member_textfield.dart';

class ChurchView extends StatefulWidget {
  const ChurchView({Key key}) : super(key: key);

  @override
  _ChurchViewState createState() => _ChurchViewState();
}

class _ChurchViewState extends State<ChurchView> {
  TextEditingController posiController, churchController;

  @override
  void initState() {
    posiController =
        TextEditingController(text: AppCache?.getUser?.profile?.churchPosition);

    String church = AppCache?.getUser?.groups == null
        ? ''
        : AppCache.getUser?.groups[0]?.name;
    churchController = TextEditingController(text: church);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.h),
                    bottomRight: Radius.circular(10.h)),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black12,
                          Colors.black.withOpacity(.9)
                        ]).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: Container(
                      height: SizeConfig.screenHeight / 3.5,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(),
                      child: Image.asset(Images.church, fit: BoxFit.fitWidth)),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 30.h,
                          width: 30.h,
                          margin: EdgeInsets.all(20.h),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.circular(4.h)),
                          child: Icon(Icons.arrow_back,
                              color: AppColors.white, size: 18.h),
                        ),
                      ),
                    ],
                  ),
                  CachedNetworkImage(
                    imageUrl: AppCache.myChurch.name ?? 'Church',
                    height: 74.h,
                    width: 74.h,
                    fit: BoxFit.fill,
                    placeholder: (BuildContext context, String url) =>
                        Image.asset(
                      Images.logo,
                      fit: BoxFit.fill,
                      height: 74.h,
                      width: 74.h,
                    ),
                    errorWidget:
                        (BuildContext context, String url, dynamic error) =>
                            Image.asset(
                      Images.logo,
                      fit: BoxFit.fill,
                      height: 74.h,
                      width: 74.h,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  regularSansText(context,
                      text: AppCache.myChurch.name ?? 'Church',
                      fontSize: 24.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600)
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          memberOption(context, 'Church Position'),
          MemberTextField(enabled: false, controller: posiController),
          memberOption(context, 'Church Department'),
          MemberTextField(controller: churchController, enabled: false),
/*          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 40.h),
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
                      text: 'Save Edits',
                      fontSize: 14.sp,
                      textColor: AppColors.white,
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
