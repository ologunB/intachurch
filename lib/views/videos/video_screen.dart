import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/youtube_model.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/video_vm.dart';
import 'package:mms_app/views/videos/youtube_player.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

ScrollController videoController = ScrollController();

class _VideoScreenState extends State<VideoScreen> {
  @override
  void dispose() {
    change();
    super.dispose();
  }

  Future<void> change() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext _) {
    final VideoViewModel provider =
        Provider.of<VideoViewModel>(context, listen: false);

    return BaseView<VideoViewModel>(
        onModelReady: (VideoViewModel model) => model.getChurchVideos(context),
        builder: (_, VideoViewModel allModel, __) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 100), () {});
              return allModel.getChurchVideos(context);
            },
            color: AppColors.primaryColor,
            child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                    title: regularSansText(context,
                        text: 'Videos',
                        fontSize: 24.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                    elevation: 0.3,
                    centerTitle: false,
                    backgroundColor: AppColors.white),
                body: ListView(
                  physics:
                      allModel.busy ? NeverScrollableScrollPhysics() : null,
                  controller:
                      allModel.allVideos == null ? null : videoController,
                  children: [
                    if (AppCache.getConvertedRecentVideos().isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 15.h),
                        child: regularSansText(context,
                            text: 'Recent',
                            fontSize: 16.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: AppCache.getConvertedRecentVideos()
                              .map((e) => InkWell(
                                    onTap: () {
                                      AppCache.saveRecentVideos(e);
                                      routeTo(context,
                                          InlineYoutubePlayer(model: e));
                                    },
                                    child: Container(
                                      width: SizeConfig.screenWidth * .7,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) {
                                                return LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(.2),
                                                      Colors.black
                                                          .withOpacity(.4)
                                                    ]).createShader(bounds);
                                              },
                                              blendMode: BlendMode.darken,
                                              child: CachedNetworkImage(
                                                imageUrl: e.image,
                                                fit: BoxFit.cover,
                                                width:
                                                    SizeConfig.screenWidth * .7,
                                                height: 110.h,
                                                placeholder: (BuildContext
                                                            context,
                                                        String url) =>
                                                    Image(
                                                        image: AssetImage(
                                                            Images.placeholder),
                                                        fit: BoxFit.cover),
                                                errorWidget: (BuildContext
                                                            context,
                                                        String url,
                                                        dynamic error) =>
                                                    Image(
                                                        image: AssetImage(
                                                            Images.babyReadImg),
                                                        fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            regularSansText(context,
                                                text: e.title,
                                                fontSize: 14.sp,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.h, right: 20.h, top: 15.h),
                      child: regularSansText(context,
                          text: 'Explore',
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15.h),
                    allModel.busy
                        ? provider?.contextVideos != null
                            ? listBody(provider.contextVideos)
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 6,
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
                        : allModel.allVideos == null
                            ? provider?.contextVideos != null
                                ? listBody(provider.contextVideos)
                                : ListView(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    children: [
                                      Container(
                                        height: SizeConfig.screenHeight / 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ErrorOccurredWidget(
                                                error: allModel?.error),
                                            SizedBox(height: 20.h),
                                            InkWell(
                                              onTap: () {
                                                allModel
                                                    .getChurchVideos(context);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6.h,
                                                      horizontal: 12.h),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.h),
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueAccent,
                                                          width: 1.h)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      regularSansText(context,
                                                          text: 'RETRY',
                                                          fontSize: 18.sp,
                                                          color:
                                                              Colors.blueAccent,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      SizedBox(width: 10.h),
                                                      Icon(
                                                        Icons.refresh_outlined,
                                                        size: 20.h,
                                                        color:
                                                            Colors.blueAccent,
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                            : allModel.allVideos.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.h, vertical: 20.h),
                                      child: regularSansText(context,
                                          text:
                                              'There are no videos currently!',
                                          fontSize: 16.sp,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.pitchBlack),
                                    ),
                                  )
                                : listBody(allModel.allVideos)
                  ],
                )),
          );
        });
  }

  Widget listBody(List<VideoModel> modelList) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100.h),
      child: ListView.builder(
          itemCount: modelList.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            VideoModel video = modelList[index];

            String time = timeago.format(DateTime.tryParse(video.timeCreated));
            return InkWell(
              onTap: () {
                AppCache.saveRecentVideos(video);
                routeTo(context, InlineYoutubePlayer(model: video));
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.h, left: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*   YoutubePlayer(
                                                  controller:
                                                      YoutubePlayerController(
                                                    initialVideoId: video.url,
                                                    flags: YoutubePlayerFlags(
                                                        autoPlay: false,
                                                        mute: true),
                                                  ),
                                                  bufferIndicator: SizedBox(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppColors
                                                                  .primaryColor),
                                                    ),
                                                    height: 50.h,
                                                    width: 50.h,
                                                  ),
                                                  showVideoProgressIndicator:
                                                      true,
                                                  progressIndicatorColor:
                                                      AppColors.primaryColor,
                                                  progressColors:
                                                      ProgressBarColors(
                                                    playedColor:
                                                        AppColors.primaryColor,
                                                    handleColor:
                                                        Colors.amberAccent,
                                                  ),
                                                  onReady: () {
                                                    //   _controller.addListener(() {});
                                                  },
                                                ),  */

                    IntrinsicHeight(
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
                              placeholder: (BuildContext context, String url) =>
                                  Image(
                                      width: SizeConfig.screenWidth,
                                      image: AssetImage(
                                          'assets/images/video-bg.png'),
                                      fit: BoxFit.cover),
                              errorWidget: (BuildContext context, String url,
                                      dynamic error) =>
                                  Image(
                                image: AssetImage('assets/images/video-bg.png'),
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
                                  color: AppColors.white.withOpacity(.76),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(40.h)),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.primaryColor,
                                size: 26.h,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.h),
                          child: CachedNetworkImage(
                            imageUrl: video.image,
                            fit: BoxFit.cover,
                            width: 42.h,
                            height: 42.h,
                            placeholder: (BuildContext context, String url) =>
                                Image(
                                    width: 42.h,
                                    height: 42.h,
                                    image: AssetImage(Images.placeholder),
                                    fit: BoxFit.cover),
                            errorWidget: (BuildContext context, String url,
                                    dynamic error) =>
                                Image(
                              image: AssetImage(Images.placeholder),
                              fit: BoxFit.cover,
                              width: 42.h,
                              height: 42.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            regularSansText(context,
                                text: video.title,
                                fontSize: 16.sp,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                            SizedBox(height: 6.h),
                            regularSansText(context,
                                text:
                                    '${video.owner ?? ''}  |  ${time.toTitleCase()}',
                                fontSize: 12.sp,
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w400),
                          ],
                        ))
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
