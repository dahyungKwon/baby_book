import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.example.baby_book";

  static String introAvailable = "${prefName}isIntroAvailable";
  static String isLoggedIn = "${prefName}isLoggedIn";
  static String getTheme = "${prefName}isSelectedTheme";
  static String getDefaultCode = "${prefName}code";
  static String getDefaultCountry = "${prefName}country";
  static String defIndexVal = "${prefName}index";
  static String modelBooking = "${prefName}bookingModel";
  static String defCountryName = "image_albania.jpg";
  static String accessToken = "${prefName}accessToken";
  static String refreshToken = "${prefName}refreshToken";
  static String memberId = "${prefName}memberId";
  static String agreed = "${prefName}agreed";
  static String lastLoginDate = "${prefName}lastLoginDate";

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static setLogIn(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLoggedIn, avail);
  }

  static setBookingModel(String avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(modelBooking, avail);
  }

  static setDefIndex(int avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setInt(defIndexVal, avail);
  }

  static setDefCode(String avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(getDefaultCode, avail);
  }

  static setCountryName(String avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(getDefaultCountry, avail);
  }

  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }

  static Future<String> getBookingModel() async {
    SharedPreferences preferences = await getPrefInstance();
    String isIntroAvailable = preferences.getString(modelBooking) ?? "";
    return isIntroAvailable;
  }

  static Future<int> getDefIndex() async {
    SharedPreferences preferences = await getPrefInstance();
    int isIntroAvailable = preferences.getInt(defIndexVal) ?? 0;
    return isIntroAvailable;
  }

  static Future<String> getDefCode() async {
    SharedPreferences preferences = await getPrefInstance();
    String isIntroAvailable = preferences.getString(getDefaultCode) ?? "+1";
    return isIntroAvailable;
  }

  static Future<String> getDefCountry() async {
    SharedPreferences preferences = await getPrefInstance();
    String isIntroAvailable = preferences.getString(getDefaultCountry) ?? defCountryName;
    return isIntroAvailable;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.getString(accessToken);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.getString(refreshToken);
  }

  static Future<String?> getMemberId() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.getString(memberId);
  }

  static Future<bool?> getAgreed() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.getBool(agreed);
  }

  static setAccessToken(String? accessTokenParam) async {
    SharedPreferences preferences = await getPrefInstance();
    if (accessTokenParam == null) {
      preferences.remove(accessToken);
    } else {
      preferences.setString(accessToken, accessTokenParam);
    }
  }

  static setRefreshToken(String? refreshTokenParam) async {
    SharedPreferences preferences = await getPrefInstance();
    if (refreshTokenParam == null) {
      preferences.remove(refreshToken);
    } else {
      preferences.setString(refreshToken, refreshTokenParam);
    }
  }

  static setMemberId(String? memberIdParam) async {
    SharedPreferences preferences = await getPrefInstance();
    if (memberIdParam == null) {
      preferences.remove(memberId);
    } else {
      preferences.setString(memberId, memberIdParam);
    }
  }

  static setAgreed(bool agreedParam) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(agreed, agreedParam);
  }

  static setLastLoginDate(DateTime? lastDate) async {
    SharedPreferences preferences = await getPrefInstance();
    if (lastDate == null) {
      preferences.remove(lastLoginDate);
    } else {
      preferences.setString(lastLoginDate, lastDate.toIso8601String());
    }
  }

  static Future<bool> needRefreshAuth() async {
    SharedPreferences preferences = await getPrefInstance();
    String? lastDateString = preferences.getString(lastLoginDate);
    if (lastDateString == null || lastDateString.isEmpty) {
      return true;
    }

    DateTime lastDateTime = DateTime.parse(lastDateString);
    DateTime lastDate = DateTime(lastDateTime.year, lastDateTime.month, lastDateTime.day);

    DateTime nowDateTime = DateTime.now();
    DateTime nowDate = DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day);

    //lastDate가 nowDate보다 지난 시간이면 refresh 해야함 (일단위)
    return lastDate.isBefore(nowDate);
  }
}
