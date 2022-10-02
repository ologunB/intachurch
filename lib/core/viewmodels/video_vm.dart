import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mms_app/core/api/video_api.dart';
import 'package:mms_app/core/models/youtube_model.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'base_vm.dart';

class VideoViewModel extends BaseModel {
  final VideoApi _videoApi = locator<VideoApi>();
  String error;
  List<VideoModel> allVideos;

  void setVideoList(List<VideoModel> value) {
    contextVideos = value;
    notifyListeners();
  }

  List<VideoModel> contextVideos;

  Future<void> getChurchVideos(BuildContext context,
      {bool isRandom = false}) async {
    setBusy(true);
    try {
      String churchUrl = await _videoApi.getChurchYoutube();
      churchUrl = churchUrl;
      /* ??
     'https://www.youtube.com/channel/UCIryTIrhDUgsLtMdorXaovw' ??
    'https://www.youtube.com/channel/UCAGBOf81jTO-BxDNU4NZnbQ' ??
        'https://www.youtube.com/channel/UCkUq-s6z57uJFUFBvZIVTyg';
        */

      if (churchUrl == null) {
        setBusy(false);
        error = 'The channel link was not specified';
      } else if (churchUrl.contains('channel')) {
        churchUrl = churchUrl.trim().split('/').last;
        _getChannel(churchUrl, isRandom, context);
      } else {
        setBusy(false);
        error = 'The link is not a channel';
      }
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  Future<void> _getChannel(
      String id, bool isRandom, BuildContext context) async {
    try {
      String churchData = await _videoApi.getChannel(id);
      print(churchData);
      _getAllVideos(churchData, isRandom, context);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  Future<void> _getAllVideos(
      String id, bool isRandom, BuildContext context) async {
    try {
      List<VideoModel> tempVal = await _videoApi.getAllVideos(id);
      context.read<VideoViewModel>().setVideoList(tempVal);

      if (isRandom) {
        allVideos = [];
        if (tempVal.length < 10) {
          allVideos = tempVal;
        } else {
          for (int i = 0; i < 5; i++) {
            Random random = Random();
            int randomNumber = random.nextInt(tempVal.length);
            allVideos.add(tempVal[randomNumber]);
          }
        }
      } else {
        allVideos = tempVal;
      }
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }
}
