/*
import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/home/notification_details_view.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/colors.dart';
import '../../app/size_config/config.dart';
import '../../core/routes/router.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,TODO
        iconTheme: IconThemeData(color: AppColors.black),
        title: regularSansText(context,
            text: 'Notifications',
            fontSize: 24.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w600),
        elevation: 0.3,
        backgroundColor: AppColors.white,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.separated(
            itemCount: 7,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (index == 0) routeTo(context, NotificationDetailsView());
                },
                highlightColor: AppColors.white,
                child: Container(
                    color: index == 2 ? AppColors.grey : null,
                    padding: EdgeInsets.only(
                        top: 12.w, bottom: 12.h, left: 15.w, right: 15.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 20.h,
                          color: Color(0xffE5E5E5),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  regularRobotoText(context,
                                      text: '●',
                                      fontSize: 14.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: regularRobotoText(context,
                                        text: index == 0
                                            ? 'Connection Request from Hafis ...'
                                            : 'The Church management',
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  regularRobotoText(context,
                                      text: 'APR  08, 11:05 AM',
                                      fontSize: 12.sp,
                                      color: AppColors.darkTextGrey,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                              SizedBox(height: 8.w),
                              regularRobotoText(context,
                                  text:
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suspendse amet tincidunt massa consequat. ',
                                  fontSize: 10.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 0);
            },
          ))
        ],
      ),
    );
  }
}
*/
