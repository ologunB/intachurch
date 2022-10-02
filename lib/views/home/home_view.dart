import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/models/youtube_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/events_vm.dart';
import 'package:mms_app/core/viewmodels/families_vm.dart';
import 'package:mms_app/core/viewmodels/video_vm.dart';
import 'package:mms_app/views/events/event_details.dart';
import 'package:mms_app/views/home/profile_view.dart';
import 'package:mms_app/views/videos/youtube_player.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/floating_navbar.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';
import '../../core/routes/router.dart';
import 'connect_request_view.dart';

ScrollController homeController = ScrollController();

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

int generalProgress;

class _HomeViewState extends State<HomeView> {
  String fName, churchName;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    fName = AppCache?.getUser?.profile?.firstName?.toTitleCase() ?? '';
    churchName = AppCache?.myChurch?.name?.toTitleCase() ?? '';
    final EventsViewModel eventProvider =
        Provider.of<EventsViewModel>(context, listen: false);

    final CarouselOptions videoCarousel = CarouselOptions(
      viewportFraction: 1,
      autoPlay: AppCache.getConvertedRecentVideos().length > 2 ? false : true,
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      disableCenter: true,
      pauseAutoPlayOnTouch: true,
    );
    return BaseView<VideoViewModel>(onModelReady: (VideoViewModel model) {
      if (AppCache.getConvertedRecentVideos().isEmpty) {
        model.getChurchVideos(context);
      }
    }, builder: (_, VideoViewModel vidModel, __) {
      return Scaffold(
          backgroundColor: AppColors.white,
          body: BaseView<FamiliesViewModel>(
              onModelReady: (FamiliesViewModel fModel) {
            fModel.getProgress();
            fModel.getReceivedConnects();
            fModel.getChurch();
          }, builder: (_, FamiliesViewModel fModel, __) {
            generalProgress = fModel.progress;
            return BaseView<EventsViewModel>(
                onModelReady: (EventsViewModel _eventModel) {
              _eventModel.getAllEvents(context);
            }, builder: (_, EventsViewModel eventModel, __) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 200), () {});
                  fModel.getChurch();
                  fModel.getProgress();
                  fModel.getReceivedConnects();
                  return eventModel.getAllEvents(context);
                },
                color: AppColors.primaryColor,
                child: ListView(children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.h),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            regularRobotoText(context,
                                text: 'Hi, $fName 😊',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            regularSansText(context,
                                text:
                                    'Welcome to ${churchName ?? 'IntaChurch'} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkTextGrey),
                          ],
                        )),
                        /*    InkWell(
                        onTap: () {TODO
                          routeTo(context, NotificationView());
                        },
                        highlightColor: AppColors.white,
                        child: Image.asset(
                          Images.notificationIcon,
                          color: AppColors.primaryColor,
                          height: 26.h,
                        ),
                      ),*/
                        SizedBox(width: 20.w),
                        InkWell(
                          onTap: () {
                            routeTo(context, ProfileView());
                          },
                          highlightColor: AppColors.white,
                          child: Container(
                            height: 30.h,
                            width: 30.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: AppColors.primaryColor),
                            child: regularRobotoText(context,
                                text: AppCache?.getUser?.profile?.firstName
                                        ?.substring(0, 1)
                                        ?.toUpperCase() ??
                                    'A',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  fModel.receivedConnects == null
                      ? SizedBox()
                      : ListView.builder(
                          itemCount: fModel.receivedConnects.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return fModel.receivedConnects[index]?.status
                                        ?.toLowerCase() ==
                                    'accepted'
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.all(12.h),
                                    margin: EdgeInsets.all(15.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.h),
                                        border: Border.all(
                                            color: AppColors.containerColor,
                                            width: 1.h)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 31.h,
                                          width: 31.h,
                                          decoration: BoxDecoration(
                                            color: Color(0xffF2C94C)
                                                .withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(4.h),
                                          ),
                                          child: Icon(
                                            Icons.info,
                                            color: Color(0xffF2C94C),
                                            size: 18.h,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        regularRobotoText(context,
                                            text:
                                                'You have a connection request. ',
                                            fontSize: 14.sp,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w400),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ConnectionRequestView(
                                                            connectData: fModel
                                                                    .receivedConnects[
                                                                index])));
                                          },
                                          child: regularSansText(context,
                                              text: 'Click here',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor),
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                  if ((fModel?.progress ?? 120) < 100)
                    GestureDetector(
                      onTap: () {
                        bottomNavbarController.jumpToPage(3);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        padding: EdgeInsets.all(15.h),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.h)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                regularSansText(context,
                                    text: 'Complete your',
                                    fontSize: 16.sp,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400),
                                SizedBox(height: 8.h),
                                regularSansText(context,
                                    text: 'Membership Form',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white),
                              ],
                            )),
                            Image.asset(Images.homeAvatar, height: 87.h),
                          ],
                        ),
                      ),
                    ),
                  if ((fModel?.progress ?? 120) < 100)
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Row(
                        children: [
                          regularSansText(context,
                              text: '${fModel.progress}%',
                              fontSize: 18.sp,
                              color: Color(0xff01384F),
                              fontWeight: FontWeight.w600),
                          SizedBox(width: 10.h),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                flex: fModel.progress,
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Expanded(
                                flex: 100 - fModel.progress,
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.darkTextGrey
                                          .withOpacity(.2),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        regularSansText(context,
                            text: 'Upcoming Events',
                            fontSize: 16.sp,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w600),
                        if ((eventModel?.allEvents?.length ?? 0) > 2)
                          GestureDetector(
                            onTap: () {
                              bottomNavbarController.jumpToPage(1);
                            },
                            child: regularSansText(context,
                                text: 'See more',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  eventModel.busy
                      ? eventProvider.contextEvents != null
                          ? eventBody(eventProvider.contextEvents)
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: 15.h, left: 15.h, right: 15.h),
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(.1),
                                      highlightColor: Colors.white60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        height: 140.h,
                                      )),
                                );
                              })
                      : eventModel.allEvents == null
                          ? eventProvider.contextEvents != null
                              ? eventBody(eventProvider.contextEvents)
                              : ErrorOccurredWidget(
                                  error: eventModel?.error ?? '')
                          : eventModel.allEvents.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.h, vertical: 20.h),
                                    child: regularSansText(context,
                                        text: 'There are no events currently!',
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.pitchBlack),
                                  ),
                                )
                              : eventBody(eventModel.allEvents),
                  if (AppCache.getConvertedRecentVideos().isNotEmpty ||
                      vidModel.allVideos != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 17.h, vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          regularSansText(context,
                              text: 'Videos',
                              fontSize: 16.sp,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w600),
                          GestureDetector(
                            onTap: () {
                              bottomNavbarController.jumpToPage(2);
                            },
                            child: regularSansText(context,
                                text: 'See more',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  if (AppCache.getConvertedRecentVideos().isNotEmpty ||
                      vidModel.allVideos != null)
                    CarouselSlider(
                        options: videoCarousel,
                        items: (AppCache.getConvertedRecentVideos().isEmpty
                                ? vidModel.allVideos
                                : AppCache.getConvertedRecentVideos())
                            .map((VideoModel video) {
                          return Builder(builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                AppCache.saveRecentVideos(video);

                                routeTo(
                                    context, InlineYoutubePlayer(model: video));
                              },
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.h),
                                  child: IntrinsicHeight(
                                    child: Stack(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black.withOpacity(.2),
                                                  Colors.black.withOpacity(.65)
                                                ]).createShader(bounds);
                                          },
                                          blendMode: BlendMode.darken,
                                          child: CachedNetworkImage(
                                            imageUrl: video.image,
                                            fit: BoxFit.cover,
                                            width: SizeConfig.screenWidth,
                                            placeholder: (BuildContext context,
                                                    String url) =>
                                                Image(
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    image: AssetImage(
                                                        'assets/images/video-bg.png'),
                                                    fit: BoxFit.cover),
                                            errorWidget: (BuildContext context,
                                                    String url,
                                                    dynamic error) =>
                                                Image(
                                              image: AssetImage(
                                                  'assets/images/video-bg.png'),
                                              fit: BoxFit.cover,
                                              width: SizeConfig.screenWidth,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 50.h,
                                            width: 50.h,
                                            decoration: BoxDecoration(
                                                color: AppColors.white
                                                    .withOpacity(.76),
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        40.h)),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: AppColors.primaryColor,
                                              size: 26.h,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          });
                        }).toList()),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: regularSansText(
                      context,
                      text: ' _ _ _ _ _ _ _ _  _ _ _ _ _ _ _ ',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  BaseView<EventsViewModel>(
                      onModelReady: (EventsViewModel quoteModel) {
                        quoteModel.getPresentQuote();
                      },
                      builder: (_, EventsViewModel quoteModel, __) =>
                          quoteModel.busy
                              ? AppCache?.getQuote == null
                                  ? CircularProgressIndicator()
                                  : quoteBody(AppCache?.getQuote?.content)
                              : quoteModel.quoteModel == null
                                  ? AppCache?.getQuote == null
                                      ? SizedBox()
                                      : quoteBody(AppCache?.getQuote?.content)
                                  : quoteBody(quoteModel.quoteModel.content)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 30.h),
                    child: InkWell(
                        onTap: () async {
                          String title = "Prayer Request";
                          String email = AppCache.myChurch.email;
                          String body = 'I have a prayer request about...';
                          String _url =
                              "mailto:$email?subject=$title&body=$body%20";
                          try {
                            await launch(_url);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.h)),
                          child: regularSansText(
                            context,
                            text: 'Send Prayer Request',
                            fontSize: 14.sp,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        )),
                  ),
                  SizedBox(height: 100.h),
                ]),
              );
            });
          }));
    });
  }

  Widget quoteBody(String a) {
    return Container(
        margin: EdgeInsets.only(left: 15.h, right: 20.h),
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
            color: Color(0xffFFF9F5),
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
                color: AppColors.darkTextGrey.withOpacity(.2), width: 2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            regularSansText(context,
                text: 'Quote of the day.',
                fontSize: 22.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400),
            SizedBox(height: 6.h),
            regularSansText(
              context,
              text: a,
              fontSize: 14.sp,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ],
        ));
  }

  Widget eventBody(List<EventModel> list) {
    final CarouselOptions eventCarousel = CarouselOptions(
      viewportFraction: 1,
      autoPlay: true,
      autoPlayAnimationDuration: Duration(milliseconds: 5000),
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      disableCenter: true,
      pauseAutoPlayOnTouch: true,
    );
    return CarouselSlider(
        options: eventCarousel,
        items: list.map((EventModel eventModelData) {
          return Builder(builder: (BuildContext context) {
            return Row(
              children: [
                SizedBox(
                  width: 15.h,
                ),
                InkWell(
                  onTap: () {
                    routeTo(context, EventDetailsView(model: eventModelData));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.h),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.8)
                                  ]).createShader(bounds);
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              imageUrl: eventModelData?.pictures == null
                                  ? 'null'
                                  : eventModelData?.pictures[0].url,
                              fit: BoxFit.fitWidth,
                              width: SizeConfig.screenWidth - 33.h,
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(Images.homeDefaultImage,
                                      fit: BoxFit.fitWidth),
                              errorWidget: (BuildContext context, String url,
                                      dynamic error) =>
                                  Image.asset(Images.homeDefaultImage,
                                      fit: BoxFit.fitWidth),
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.all(15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              regularSansText(context,
                                  text: eventModelData.title,
                                  fontSize: 22.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600),
                              regularSansText(
                                context,
                                text: DateFormat('MMMM dd  ● ').format(
                                        DateTime.parse(
                                            eventModelData.startDate)) +
                                    eventModelData.startTime +
                                    ' WAT',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffB0B0B0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          });
        }).toList());
  }
}
