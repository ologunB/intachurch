import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/quote_model.dart';
import 'package:mms_app/core/models/youtube_model.dart';

const String kUserBox = 'userBox';
const String profileKey = 'profile';
const String isFirstKey = 'isTheFirst';
const String recentSearchesKey = 'recentSearches';
const String notificationKey = 'notification';
const String myTokenKey = 'myToken';
const String churchKey = 'churchString';
const String quoteKey = 'quote';
const String whoMeKey = 'whoMe';
const String videoKey = 'videommmmmm';

class AppCache {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(kUserBox);
  }

  static Box<dynamic> get _userBox => Hive.box<dynamic>(kUserBox);

  static void haveFirstView(bool t) {
    if (isFirstKey == null) {
      return;
    }
    _userBox.put(isFirstKey, t);
  }

  static bool getIsFirst() {
    final bool data = _userBox.get(isFirstKey) ?? true;
    return data;
  }

  static void setUser(LoginData user) {
    _userBox.put(profileKey, user.toJson());
  }

  static LoginData get getUser {
    final dynamic data = _userBox.get(profileKey);
    if (data == null) {
      return null;
    }
    final LoginData user = LoginData.fromJson(data);
    return user;
  }

  static Future<void> clear() async {
    await _userBox.clear();
  }

  static void clean(String key) {
    _userBox.delete(key);
  }

  static void saveRecentSearch(String id) {
    if (id == null) {
      return;
    }
    id = id.trim();
    List<String> list = getRecentSearches();
    list.add(id);
    list = list.toSet().toList();
    _userBox.put(recentSearchesKey, list);
  }

  static List<String> getRecentSearches() {
    final dynamic data =
        _userBox.get(recentSearchesKey, defaultValue: <String>[]);
    if (data == null) {
      return <String>[];
    }
    final List<String> list = List<String>.from(data as List<String>);
    return list;
  }

  static bool get shouldNotify {
    if (_userBox.containsKey(notificationKey)) {
      return _userBox.get(notificationKey);
    } else {
      return true;
    }
  }

  static void setShouldNotify(bool type) async {
    await _userBox.put(notificationKey, type);
  }

  static String get myToken {
    if (_userBox.containsKey(myTokenKey)) {
      return _userBox.get(myTokenKey);
    } else {
      return null;
    }
  }

  static void setMyToken(String type) async {
    await _userBox.put(myTokenKey, type);
  }

  static String get myRelationship {
    if (_userBox.containsKey(whoMeKey)) {
      return _userBox.get(whoMeKey);
    } else {
      return 'Father';
    }
  }

  static void setMyRelationship(String type) async {
    await _userBox.put(whoMeKey, type);
  }

  static void setMyChurch(Church user) {
    _userBox.put(churchKey, user.toJson());
  }

  static Church get myChurch {
    final dynamic data = _userBox.get(churchKey);
    if (data == null) {
      return null;
    }
    final Church user = Church.fromJson(data);
    return user;
  }

  static void setQuote(QuoteModel user) {
    if (user == null) return;
    _userBox.put(quoteKey, user.toJson());
  }

  static QuoteModel get getQuote {
    final dynamic data = _userBox.get(quoteKey);
    if (data == null) {
      return QuoteModel(content: '');
    }
    final QuoteModel user = QuoteModel.fromJson(data);
    return user;
  }

  static void saveRecentVideos(VideoModel video) {
    if (video == null) {
      return;
    }
    List<dynamic> list = _getRecentVideos();

    list.removeWhere(
        (element) => element['videoId'] == video.toSavedJson()['videoId']);

    list.add(video.toSavedJson());

    // make the list strictly 10
    List<dynamic> tempList = [];
    list = list.reversed.toList();
    if (list.length > 10) {
      for (int i = 0; i < 10; i++) {
        tempList.add(list[i]);
      }
    } else {
      tempList = list;
    }
    _userBox.put(videoKey, tempList);
  }

  static List<dynamic> _getRecentVideos() {
    final dynamic data =
        _userBox.get(videoKey, defaultValue: <Map<String, dynamic>>[]);
    if (data == null) {
      return <Map<String, dynamic>>[];
    }
    return data;
  }

  static List<VideoModel> getConvertedRecentVideos() {
    final List<VideoModel> list = [];
    _getRecentVideos().forEach((element) {
      list.add(VideoModel.fromSavedJson(element));
    });
    return list;
  }
}
