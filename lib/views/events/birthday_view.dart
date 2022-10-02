import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/events_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class BirthdayView extends StatefulWidget {
  const BirthdayView({Key key}) : super(key: key);

  @override
  _BirthdayViewState createState() => _BirthdayViewState();
}

class _BirthdayViewState extends State<BirthdayView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<EventsViewModel>(
        onModelReady: (EventsViewModel model) {
          model.getTodayCelebrants();
          model.getTomoCelebrants();
          model.getYesteCelebrants();
        },
        builder: (_, EventsViewModel model, __) => model.busy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50.h,
                      width: 50.h,
                      child: CircularProgressIndicator())
                ],
              )
            : model.todayCelebrants == null &&
                    model.yesterCelebrants == null &&
                    model.tomoCelebrants == null
                ? ListView(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight / 1.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ErrorOccurredWidget(error: model.error),
                            SizedBox(height: 40.h),
                            InkWell(
                              onTap: () {
                                model.getTodayCelebrants();
                                model.getTomoCelebrants();
                                model.getYesteCelebrants();
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 12.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.h),
                                      border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 1.h)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      regularSansText(context,
                                          text: 'RETRY',
                                          fontSize: 18.sp,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w600),
                                      SizedBox(width: 10.h),
                                      Icon(
                                        Icons.refresh_outlined,
                                        size: 20.h,
                                        color: Colors.blueAccent,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Scaffold(
                    backgroundColor: Colors.white,
                    body: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      children: [
                        if (model?.todayCelebrants?.isNotEmpty ?? false)
                          regularSansText(context,
                              text: 'Celebrating their birthday Today',
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ListView.builder(
                            itemCount: model?.todayCelebrants?.length ?? 0,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            itemBuilder: (context, index) {
                              return item(model
                                  .todayCelebrants[index].profile.fullName);
                            }),
                        SizedBox(height: 10.h),
                        if (model?.tomoCelebrants?.isNotEmpty ?? false)
                          regularSansText(context,
                              text: 'Celebrating their birthday Tomorrow',
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ListView.builder(
                            itemCount: model?.tomoCelebrants?.length ?? 0,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            itemBuilder: (context, index) {
                              return item(
                                  model.tomoCelebrants[index].profile.fullName);
                            }),
                        SizedBox(height: 10.h),
                        if (model?.yesterCelebrants?.isNotEmpty ?? false)
                          regularSansText(context,
                              text: 'Celebrating their birthday Yesterday',
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ListView.builder(
                            itemCount: model?.yesterCelebrants?.length ?? 0,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            itemBuilder: (context, index) {
                              return item(model
                                  .yesterCelebrants[index].profile.fullName);
                            }),
                        if (model?.yesterCelebrants?.isEmpty ?? false)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.h),
                            child: regularSansText(context,
                                text: 'There were no celebrants yesterday!',
                                fontSize: 16.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                color: AppColors.pitchBlack),
                          ),
                        SizedBox(height: 10.h),
                        if (model?.todayCelebrants?.isEmpty ?? false)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.h),
                            child: regularSansText(context,
                                text: 'There are no celebrants today!',
                                fontSize: 16.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                color: AppColors.pitchBlack),
                          ),
                        SizedBox(height: 10.h),
                        if (model?.tomoCelebrants?.isEmpty ?? false)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.h),
                            child: regularSansText(context,
                                text: 'There are no celebrants tomorrow!',
                                fontSize: 16.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                color: AppColors.pitchBlack),
                          ),
                      ],
                    ),
                  ));
  }

  Widget item(String name) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.h),
                color: randomGenerator()),
            child: regularRobotoText(context,
                text: 'A',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
          SizedBox(width: 18.h),
          regularSansText(context,
              text: name,
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ],
      ),
    );
  }

  final List<Color> circleColors = <Color>[
    Colors.lightBlueAccent,
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.deepOrange,
    Colors.amberAccent,
    Colors.teal,
    Colors.blueAccent,
    Colors.blue,
    Colors.green,
    Colors.purpleAccent,
    Colors.deepOrange,
    Colors.amberAccent,
    Colors.teal,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.deepOrange,
    Colors.amberAccent,
    Colors.teal
  ];

  Color randomGenerator() {
    return circleColors[Random().nextInt(circleColors.length)];
  }
}
