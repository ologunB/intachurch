import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../../app/colors.dart';
import '../../../app/size_config/config.dart';

class MemberHeaderItem extends StatelessWidget {
  const MemberHeaderItem(
      {Key key,
      this.title,
      this.image,
      this.editFtn,
      this.editColor,
      this.isEdit = true})
      : super(key: key);

  final String title;
  final String image;
  final bool isEdit;
  final Function() editFtn;
  final Color editColor;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SafeArea(
        child: Stack(
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
                      colors: [Colors.black12, Colors.black.withOpacity(.9)])
                  .createShader(bounds);
            },
            blendMode: BlendMode.darken,
            child: Container(
                height: SizeConfig.screenHeight / 3.5,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(),
                child: Image.asset(image, fit: BoxFit.fitWidth)),
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 30.h,
            width: 30.h,
            margin: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.5),
                borderRadius: BorderRadius.circular(4.h)),
            child: Icon(Icons.arrow_back, color: AppColors.white, size: 18.h),
          ),
        ),
        Positioned(
            bottom: 20.h,
            left: 20.w,
            child: regularSansText(context,
                text: title,
                fontSize: 24.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600)),
        Positioned(
            bottom: 20.h,
            right: 20.w,
            child: regularSansText(context,
                text: '' ?? '30% done',
                fontSize: 14.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w400)),
        if (isEdit != null)
          Positioned(
              top: 20.h,
              right: 20.w,
              child: !isEdit
                  ? SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      height: 20.h,
                      width: 20.w,
                    )
                  : InkWell(
                      onTap: editFtn,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.h),
                            color: Colors.white),
                        child: regularSansText(context,
                            text: 'Edit',
                            fontSize: 14.sp,
                            color: editColor,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
      ],
    ));
  }
}
