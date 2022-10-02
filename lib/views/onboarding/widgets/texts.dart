import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

Widget topText(BuildContext context, {String text}) {
  return Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: regularSansText(
      context,
      text: '$text',
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
    ),
  );
}

Widget subText(BuildContext context, {String text}) {
  return regularSansText(
    context,
    text: '$text',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    textAlign: TextAlign.center,
  );
}
