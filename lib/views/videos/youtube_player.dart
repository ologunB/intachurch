import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkify/linkify.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/youtube_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/video_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InlineYoutubePlayer extends StatefulWidget {
  const InlineYoutubePlayer({Key key, @required this.model}) : super(key: key);

  final VideoModel model;

  @override
  _InlineYoutubePlayerState createState() => _InlineYoutubePlayerState();
}

class _InlineYoutubePlayerState extends State<InlineYoutubePlayer> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.model.url,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    super.initState();
  }

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
    return OrientationBuilder(
        builder: (BuildContext _, Orientation orientation) {
      return Scaffold(
          //  extendBodyBehindAppBar: orientation == Orientation.landscape,
          appBar: orientation == Orientation.landscape
              ? null
              : AppBar(
                  centerTitle: true,
                  title: regularSansText(context,
                      text: 'Video',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white,
                ),
          body: ListView(
            children: [
              Stack(
                children: [
                  YoutubePlayerBuilder(
                    builder: (context, player) {
                      return player;
                    },
                    player: YoutubePlayer(
                      aspectRatio: orientation == Orientation.landscape
                          ? SizeConfig.screenWidth / SizeConfig.screenHeight
                          : (16 / 9),
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.primaryColor,
                      progressColors: ProgressBarColors(
                        playedColor: AppColors.primaryColor,
                        handleColor: Colors.amberAccent,
                      ),
                      onReady: () {
                        _controller.addListener(() {});
                      },
                    ),
                  ),
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              _controller.toggleFullScreenMode();
                            },
                            child: SafeArea(
                              child: Container(
                                padding: EdgeInsets.all(8.h),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.close,
                                  size: 12.w,
                                ),
                                margin: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.w),
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              ExpansionDesc(model: widget.model),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                child: regularSansText(context,
                    text: 'Other Videos',
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600),
              ),
              BaseView<VideoViewModel>(onModelReady: (VideoViewModel model) {
                model.getChurchVideos(context, isRandom: true);
              }, builder: (_, VideoViewModel allModel, __) {
                return allModel.busy
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
                                      height: 100.h,
                                    )),
                              );
                            })
                    : allModel.allVideos == null
                        ? provider.contextVideos != null
                            ? listBody(provider.contextVideos)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight / 3,
                                    alignment: Alignment.center,
                                    child: regularSansText(context,
                                        text: allModel.error,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.red),
                                  )
                                ],
                              )
                        : allModel.allVideos.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40.h, vertical: 20.h),
                                  child: regularSansText(context,
                                      text: 'There are no videos currently!',
                                      fontSize: 16.sp,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.pitchBlack),
                                ),
                              )
                            : listBody(allModel.allVideos);
              })
            ],
          ));
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
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InlineYoutubePlayer(
                              model: video,
                            )));
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.h, left: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

class ExpansionDesc extends StatefulWidget {
  const ExpansionDesc({Key key, this.model}) : super(key: key);
  final VideoModel model;

  @override
  _ExpansionDescState createState() => _ExpansionDescState();
}

class _ExpansionDescState extends State<ExpansionDesc> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    String time = timeago.format(DateTime.tryParse(widget.model.timeCreated));

    return ExpansionTile(
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      tilePadding: EdgeInsets.zero,
      title: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            regularSansText(context,
                text: widget.model.title,
                fontSize: 16.sp,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
                fontWeight: FontWeight.w600),
            SizedBox(height: 6.h),
            regularSansText(context,
                text: '${widget.model.owner ?? ''}  |  ${time.toTitleCase()}',
                fontSize: 12.sp,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w400),
          ],
        ),
      ),
      trailing: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
        child: Icon(
          value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.grey,
          size: 24.h,
        ),
      ),
      onExpansionChanged: (a) {
        value = !value;
        setState(() {});
      },
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: regularSansText(context,
              text: 'Description:',
              fontSize: 16.sp,
              overflow: TextOverflow.ellipsis,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.h),
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
              options: LinkifyOptions(humanize: true, removeWww: true),
              text: widget?.model?.desc ?? '',
              style: GoogleFonts.openSans(color: Colors.black, fontSize: 13.sp),
              linkStyle: GoogleFonts.openSans(
                  color: Colors.blueAccent,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400),
            )),
        SizedBox(height: 10.h)
      ],
    );
  }
}
