import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../../app/colors.dart';
import '../../../app/size_config/config.dart';

class MemberItem extends StatelessWidget {
  const MemberItem(
      {Key key, this.image, this.title,this.isDone})
      : super(key: key);
  final String image;
  final String title;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
        margin: EdgeInsets.only(top: 15.h, left: 15.h, right: 15.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.h)),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.h),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black12,
                          Colors.black.withOpacity(.8)
                        ]).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: Image.asset(image, fit: BoxFit.fitWidth),
                )),
            Padding(
                padding: EdgeInsets.all(15.h),
                child: Row(
                  children: [
                    regularSansText(context,
                        text: title,
                        fontSize: 24.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600),
                    SizedBox(width: 5.w),
                    Icon(
                      isDone ? Icons.check_circle : Icons.info_sharp,
                      size: 20.h,
                      color: isDone ? Color(0xff4CD964) : Colors.amber,
                    )
                  ],
                )),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(15.h),
                child: regularSansText(
                  context,
                  text: 'STATUS: ${isDone ? 'COMPLETED' : 'UNCOMPLETED'}',
                  fontSize: 12.sp,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ));
  }
}
