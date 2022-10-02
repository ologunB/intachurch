/*
import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/colors.dart';
import '../../app/size_config/config.dart';

class NotificationDetailsView extends StatelessWidget {
  const NotificationDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.black),
        backgroundColor: AppColors.white,
        title: regularSansText(context,
            text: 'Notification',
            fontSize: 20,
            color: AppColors.black,
            fontWeight: FontWeight.w400),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                regularRobotoText(context,
                    text: 'The Church management',
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
                regularRobotoText(context,
                    text: 'APR  08, 11:05 AM',
                    fontSize: 12.sp,
                    color: AppColors.darkTextGrey,
                    fontWeight: FontWeight.w400),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
            child: regularRobotoText(context,
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat.',
                fontSize: 11.5.sp,
                color: AppColors.black,
                textAlign: TextAlign.justify,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }TODO
}
*/
