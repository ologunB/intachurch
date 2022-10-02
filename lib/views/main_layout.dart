import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/home/home_view.dart';
import 'package:mms_app/views/videos/video_screen.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/floating_navbar.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/size_config/config.dart';
import 'events/event_layout.dart';
import 'membership/membership_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(
        onModelReady: (AuthViewModel m) {
          m.updateToken();
        },
        builder: (_, __, ___) => FloatingNavBar(
              color: Colors.white,
              selectedIconColor: AppColors.primaryColor,
              unselectedIconColor: AppColors.textGrey,
              borderRadius: 30.h,
              items: [
                FloatingNavBarItem(iconData: Images.homeIcon, page: HomeView()),
                FloatingNavBarItem(
                    iconData: Images.eventsIcon,
                    page: /*Text('data') ??*/ EventLayout()),
                FloatingNavBarItem(
                    iconData: Images.videoIcon, page: VideoScreen()),
                FloatingNavBarItem(
                    iconData: Images.profileIcon, page: MembershipView()),
              ],
              horizontalPadding: 60.w,
              hapticFeedback: true,
            ));
  }
}
