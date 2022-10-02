import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/core/models/youtube_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';

import 'base_api.dart';

class VideoApi extends BaseAPI {
  Logger log = Logger();

  Future<String> getChurchYoutube() async {
    final int id = AppCache.myChurch.id;
    final String url = '$baseUrl/churches/$id/youtube-channel-link';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

    //    log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return res.data['data']['youtube_channel_link'];
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> getChannel(String id) async {
    final String url = 'www.googleapis.com';

    Map<String, dynamic> params = {
      'part': 'snippet, contentDetails, statistics',
      'id': id,
      'key': ytKey
    };

    Uri uri = Uri.https(url, '/youtube/v3/channels', params);

    //  print(uri.toString());
    try {
      final Response<dynamic> res =
          await dio.getUri<dynamic>(uri, options: defaultOptions);

      // log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return res.data['items'][0]['contentDetails']['relatedPlaylists']
                ['uploads'];
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      //   log.d(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<VideoModel>> getAllVideos(String id, {int page = 0}) async {
    final String url = 'www.googleapis.com';

    Map<String, dynamic> params = {
      'part': 'snippet, contentDetails',
      'maxResults': '20',
      'chart': 'chartUnspecified',
      'playlistId': id,
      'key': ytKey
    };

    Uri uri = Uri.https(url, '/youtube/v3/playlistItems', params);
    //  print(uri.toString());

    try {
      final Response<dynamic> res =
          await dio.getUri<dynamic>(uri, options: defaultOptions);

      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return VideoResponse.fromJson(res.data).data;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['error']['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      //    log.d(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }
}
