import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({Key key, this.model}) : super(key: key);

  final EventModel model;

  @override
  _EventDetailsViewState createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.h),
                    bottomRight: Radius.circular(10.h)),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.75)
                        ]).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: Container(
                    height: SizeConfig.screenHeight / 3,
                    color: AppColors.textGrey,
                    child: PageView(
                      onPageChanged: (a) {
                        _index = a;
                        setState(() {});
                      },
                      children: (widget?.model?.pictures ??
                              [Pictures(url: 'em')])
                          .map(
                            (e) => CachedNetworkImage(
                              imageUrl: e.url,
                              fit: BoxFit.cover,
                              placeholder: (BuildContext context, String url) =>
                                  Image(
                                      image: AssetImage(Images.placeholder),
                                      fit: BoxFit.cover),
                              errorWidget: (BuildContext context, String url,
                                      dynamic error) =>
                                  Image(
                                      image: AssetImage(Images.babyReadImg),
                                      fit: BoxFit.cover),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 33.h,
                    width: 35.h,
                    margin: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        borderRadius: BorderRadius.circular(5.h)),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.white, size: 18.h),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 25.h,
                    alignment: Alignment.center,
                    child: ListView.builder(
                        itemCount: widget?.model?.pictures?.length ?? 1,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(6.h),
                                child: Container(
                                    height: 10.h,
                                    width: 10.h,
                                    decoration: BoxDecoration(
                                        color: _index == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(.5),
                                        borderRadius:
                                            BorderRadius.circular(22))),
                              )
                            ],
                          );
                        }),
                  )),
              Positioned(
                bottom: -22.h,
                right: 20.h,
                child: InkWell(
                  onTap: () {
                    final String msgBody =
                        'Check out this cool app where I get christian videos';

                    Share.share(msgBody, subject: 'Look it up');
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    padding: EdgeInsets.all(15.h),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Image.asset(
                      Images.shareIcon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: AppColors.lightTextGrey, size: 18.h),
                SizedBox(width: 10.w),
                regularSansText(context,
                    text: DateFormat('MMMM dd')
                        .format(DateTime.parse(widget.model.startDate)),
                    fontSize: 16.sp,
                    color: AppColors.lightTextGrey,
                    fontWeight: FontWeight.w400),
                SizedBox(width: 20.w),
                Icon(Icons.access_time_outlined,
                    color: AppColors.lightTextGrey, size: 20.h),
                SizedBox(width: 10.w),
                regularSansText(context,
                    text: '${widget.model.startTime} WAT',
                    fontSize: 16.sp,
                    color: AppColors.lightTextGrey,
                    fontWeight: FontWeight.w400),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: regularSansText(context,
                text: widget.model.title,
                fontSize: 24.sp,
                color: AppColors.lightTextGrey,
                fontWeight: FontWeight.w600),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                textAlign: TextAlign.justify,
                options: LinkifyOptions(humanize: true, removeWww: true),
                text: widget.model.description,
                style: GoogleFonts.openSans(
                    color: AppColors.textGrey, fontSize: 14.sp),
                linkStyle: GoogleFonts.openSans(
                    color: Colors.blueAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400),
              )),
          /*       Padding(TODO
            padding: EdgeInsets.all(20.h),
            child: regularSansText(context,
                text: 'Others',
                fontSize: 18.sp,
                color: AppColors.lightTextGrey,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Image.asset(Images.person, height: 34.h),
                      SizedBox(width: 10.w),
                      regularSansText(context,
                          text: 'Pst. Hafis Raji',
                          fontSize: 14.sp,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Image.asset(Images.person, height: 34.h),
                      SizedBox(width: 10.w),
                      regularSansText(context,
                          text: 'Pst. Hafis Raji',
                          fontSize: 14.sp,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                )
              ],
            ),
          ),*/
          SizedBox(height: 200.h)
        ],
      ),
    );
  }
}
