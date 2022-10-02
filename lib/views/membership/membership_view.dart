import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/home/home_view.dart';
import 'package:mms_app/views/membership/widgets/member_item.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';
import '../../core/routes/router.dart';
import 'about_you_view.dart';
import 'church_view.dart';
import 'edit_family_view.dart';

class MembershipView extends StatefulWidget {
  const MembershipView({Key key}) : super(key: key);

  @override
  _MembershipViewState createState() => _MembershipViewState();
}

class _MembershipViewState extends State<MembershipView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          title: regularSansText(context,
              text: 'Membership',
              fontSize: 24.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600),
          elevation: 0.3,
          centerTitle: false,
          backgroundColor: AppColors.white),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              routeTo(context, AboutYouView());
            },
            highlightColor: AppColors.white,
            child: MemberItem(
              image: Images.aboutYou,
              title: 'About you',
              isDone: (generalProgress ?? 0) == 100,
            ),
          ),
          InkWell(
              onTap: () {
                routeTo(context, EditFamilyView());
              },
              highlightColor: AppColors.white,
              child: MemberItem(
                image: Images.family,
                title: 'Family',
                isDone: (generalProgress ?? 0) == 100,
              )),
          InkWell(
              onTap: () {
                routeTo(context, ChurchView());
              },
              highlightColor: AppColors.white,
              child: MemberItem(
                image: Images.church,
                title: 'Church',
                isDone: true,
              )),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
