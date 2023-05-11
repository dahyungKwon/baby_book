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
    String isIntroAvailable =
        preferences.getString(getDefaultCountry) ?? defCountryName;
    return isIntroAvailable;
  }
}
