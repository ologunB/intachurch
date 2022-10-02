import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/events/event_view.dart';
import 'package:mms_app/views/home/home_view.dart';
import 'package:mms_app/views/videos/video_screen.dart';

import '../../app/size_config/config.dart';

PageController bottomNavbarController = PageController();

// ignore: must_be_immutable
class FloatingNavBar extends StatefulWidget {
  /// The items to be displayed on the navbar
  List<FloatingNavBarItem> items;

  /// The color of the navbar card
  Color color;

  /// The color of unselected page icons
  Color unselectedIconColor;

  /// The color of selected page icons
  Color selectedIconColor;

  /// The horizontal padding between the navbar card and the page
  double horizontalPadding;

  /// Allow haptic feedback on page change
  bool hapticFeedback;

  /// The border radius of the navbar card
  double borderRadius;

  /// The width of the navbar card
  double cardWidth;

  FloatingNavBar({
    Key key,
    this.borderRadius = 15,
    this.cardWidth,
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = Colors.white,
    @required this.horizontalPadding,
    @required this.items,
    @required this.color,
    @required this.hapticFeedback,
  })  : assert(items.length > 1),
        assert(items.length <= 5);

  @override
  _FloatingNavBarState createState() {
    return _FloatingNavBarState();
  }
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: bottomNavbarController,
              children: widget.items.map((item) => item.page).toList(),
              onPageChanged: (index) => this._changePage(index),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20.h,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: widget.horizontalPadding,
                ),
                child: Container(
                  height: 70.h,
                  width: widget.cardWidth ?? MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 15.h,
                    color: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          _widgetsBuilder(widget.items, widget.hapticFeedback),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_floatingNavBarItem] will build and return a [FloatingNavBar] item widget
  Widget _floatingNavBarItem(
      FloatingNavBarItem item, int index, bool hapticFeedback) {
    return FutureBuilder(
        future: Future.value(true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: () {
                  // If haptic feedback is set to true then use mediumImpact on FloatingNavBarItem tap
                  if (hapticFeedback == true) {
                    HapticFeedback.mediumImpact();
                  }
                  _changePage(index);
                },
                child: Container(
                  padding: EdgeInsets.all(6.h),
                  width: 50.h,
                  child: Image.asset(
                    item.iconData,
                    color: bottomNavbarController.page.toInt() == index
                        ? widget.selectedIconColor
                        : widget.unselectedIconColor,
                    height: 22.h,
                  ),
                ),
              ),
              Container(
                height: 5.h,
                width: 5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bottomNavbarController.page.toInt() == index
                      ? widget.selectedIconColor
                      : Colors.transparent,
                ),
              )
            ],
          );
        });
  }

  /// [_widgetsBuilder] adds widgets from [_floatingNavBarItem] into a List<Widget> and returns the list
  List<Widget> _widgetsBuilder(
      List<FloatingNavBarItem> items, bool hapticFeedback) {
    List<Widget> _floatingNavBarItems = [];
    for (int i = 0; i < items.length; i++) {
      Widget item = this._floatingNavBarItem(items[i], i, hapticFeedback);
      _floatingNavBarItems.add(item);
    }
    return _floatingNavBarItems;
  }

  /// [_changePage] changes selected page index so as to change the page being currently viewed by the user
  _changePage(index) {
    if (index == 0) {
      moveUp(homeController);
    } else if (index == 1) {
      moveUp(eventController);
    } else if (index == 2) {
      moveUp(videoController);
    }
    bottomNavbarController.jumpToPage(index);
    setState(() {});
  }
}

void moveUp(ScrollController control) {
  if (control.hasClients)
    control.animateTo(control.position.minScrollExtent - 60,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
}

class FloatingNavBarItem {
  String iconData;
  Widget page;

  FloatingNavBarItem({@required this.iconData, @required this.page});
}
