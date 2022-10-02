import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import 'birthday_view.dart';
import 'event_view.dart';

class EventLayout extends StatefulWidget {
  const EventLayout({Key key}) : super(key: key);

  @override
  _EventLayoutState createState() => _EventLayoutState();
}

class _EventLayoutState extends State<EventLayout> {
  int index = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: regularSansText(context,
              text: 'Events',
              fontSize: 24.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600),
          elevation: 0.3,
          centerTitle: false,
          backgroundColor: AppColors.white),
      body: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 50.h, vertical: 20.h),
            decoration: BoxDecoration(
                color: Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(30.h)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                header(0, 'Events'),
                header(1, 'Birthdays'),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              physics: ClampingScrollPhysics(),
              onPageChanged: (a) {
                setState(() => index = a);
              },
              children: [
                EventView(),
                BirthdayView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget header(int a, String name) {
    bool i = index == a;
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() => index = a);
          controller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Container(
          height: 45.h,
          width: 130.h,
          margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
              color: i ? AppColors.primaryColor : Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(30.h)),
          child: regularSansText(context,
              text: name,
              color: i ? AppColors.white : AppColors.textGrey,
              textAlign: TextAlign.center,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
