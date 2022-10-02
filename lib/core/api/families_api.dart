import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/core/models/connect_model.dart';
import 'package:mms_app/core/models/family_tree_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';

import 'base_api.dart';

class FamiliesApi extends BaseAPI {
  Logger log = Logger();

  Future<List<Profile>> searchUsers(String a) async {
    final String url = '$baseUrl/users/search?searchTerm=$a';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<Profile> list = [];
            res.data['data'].forEach((a) {
              list.add(Profile.fromJson(a));
            });
            return list;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> sendAdultRequest(Map<String, dynamic> data) async {
    final String url = '$baseUrl/families/connections/connect-adult-child';
    try {
      final Response<dynamic> res = await dio.post<dynamic>(url,
          data: data,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.statusCode);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return true;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        case 400:
          throw res.data['message'].first;
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> sendChildRequest(Map<String, dynamic> data) async {
    final String url = '$baseUrl/families/connections/connect-under-aged-child';
    try {
      final Response<dynamic> res = await dio.post<dynamic>(url,
          data: data,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return true;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        case 422:
          throw res.data['message'].first;
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<String> getAccProgress() async {
    int id = AppCache.getUser.id;
    final String url = '$baseUrl/users/$id/profile-percent-completion';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      //  log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return res.data['data'];
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

  Future<bool> sendSpouseRequest(Map<String, dynamic> data) async {
    print(data);
    final String url = '$baseUrl/families/connections/connect-spouse';
    try {
      final Response<dynamic> res = await dio.post<dynamic>(url,
          data: data,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.statusCode);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return true;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        case 422:
          throw res.data['message'].first;
          break;
        default:
          throw res.data['message'] ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<ConnectData>> getSentConnects() async {
    final String url = '$baseUrl/families/connections/sent-connections';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return ConnectResponse.fromJson(res.data).data;
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

  Future<List<ConnectData>> getReceivedConnects() async {
    final String url = '$baseUrl/families/connections/received-connections';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      // log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return ConnectResponse.fromJson(res.data).data;
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

  Future<Church> getChurch() async {
    final int id = AppCache.getUser.churchId;
    final String url = '$baseUrl/churches/$id';

    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      //  log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return Church.fromJson(res.data['data']);
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

  Future<FamilyData> getFamilyTree() async {
    final String url = '$baseUrl/users/family';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return FamilyTreeResponse.fromJson(res.data).data;
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

  Future<bool> rejectConnectRequest(int id) async {
    final String url = '$baseUrl/families/connections/$id/reject-connection';
    try {
      final Response<dynamic> res = await dio.put<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return true;
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

  Future<bool> acceptConnectRequest(int id) async {
    final String url = '$baseUrl/families/connections/$id/accept-connection';
    try {
      final Response<dynamic> res = await dio.put<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return true;
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
}
