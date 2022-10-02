import 'package:flutter/material.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/onboarding/widgets/texts.dart';
import 'package:mms_app/views/widgets/image_widget.dart';

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              topText(context, text: 'View Events and Join'),
              SizedBox(height: 10.h),
              subText(context, text: ''

                  //TODO   'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit. Proin.',
                  ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(child: ImageWidget(image: Images.onboard2)),
      ],
    );
  }
}
