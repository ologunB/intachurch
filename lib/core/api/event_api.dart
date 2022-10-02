import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/quote_model.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';

import 'base_api.dart';

class EventApi extends BaseAPI {
  Logger log = Logger();

  Future<QuoteModel> getQuote() async {
    final String url = '$baseUrl/quotes/daily-qoute';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return QuoteResponse.fromJson(res.data).data;
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

  Future<List<EventModel>> getAllEvents({int page = 1}) async {
    final String url = '$baseUrl/events/me';

    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      //  log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return EventsResponse.fromJson(res.data).data;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<LoginData>> getTodayCelebrants() async {
    final String url = '$baseUrl/users/today-birthdays';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<LoginData> all = [];
            res.data['data'].forEach((v) {
              all.add(LoginData.fromJson(v));
            });
            return all;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<LoginData>> getYesteCelebrants() async {
    final String url = '$baseUrl/users/yesterday-birthdays';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<LoginData> all = [];
            res.data['data'].forEach((v) {
              all.add(LoginData.fromJson(v));
            });
            return all;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<LoginData>> getTomoCelebrants() async {
    final String url = '$baseUrl/users/tomorrow-birthdays';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<LoginData> all = [];
            res.data['data'].forEach((v) {
              all.add(LoginData.fromJson(v));
            });
            return all;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<EventModel>> searchEvents(String a) async {
    final String url = '$baseUrl/events/search/me?searchTerm=$a';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return EventsResponse.fromJson(res.data).data;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }
}
