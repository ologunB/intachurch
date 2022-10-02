import 'package:flutter/cupertino.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../../app/colors.dart';
import '../../../app/size_config/config.dart';

Widget memberOption(BuildContext context, String text) {
  SizeConfig.init(context);
  return Padding(
    padding: EdgeInsets.all(15.h),
    child: regularSansText(context,
        text: text,
        fontSize: 14.sp,
        color: AppColors.lightTextGrey,
        fontWeight: FontWeight.w600),
  );
}
