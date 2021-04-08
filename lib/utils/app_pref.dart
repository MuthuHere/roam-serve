import 'package:shared_preferences/shared_preferences.dart';


const String PREF_IS_LOGGED_IN = "isLoggedIn";
const String PREF_ACCESS_TOKEN = "accessToken";
const String PREF_USER_MOBILE = "userMobile";
const String PREF_VCP_CODE = "userCode";
const String PREF_PROFILE_MODEL ='PREF_PROFILE_MODEL';

class AppPref {

  static AppPref _instance;
  static SharedPreferences _preferences;

  static Future<AppPref> getInstance() async {

    if (_instance == null) {
      _instance = AppPref();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    return value;
  }

  clear() {
    _preferences.clear();
  }

  bool get isLoggedIn => _getFromDisk(PREF_IS_LOGGED_IN);

  set isLoggedIn(bool isLoggedIN) => _saveToDisk(PREF_IS_LOGGED_IN, isLoggedIN);

  String get userMobile => _getFromDisk(PREF_USER_MOBILE);

  set userMobile(String mobile) => _saveToDisk(PREF_USER_MOBILE, mobile);

  String get userCode => _getFromDisk(PREF_VCP_CODE);

  set userCode(String userCode) => _saveToDisk(PREF_VCP_CODE, userCode);


}