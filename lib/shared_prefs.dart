import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences prefs;

  static Future<void> setEmail(String email) async {
    await prefs.setString("email", email);
  }

  static String getEmail() {
    return prefs.getString("email") ?? "";
  }

  static Future<void> setName(String name) async {
    await prefs.setString("name", name);
  }

  static String getName() {
    return prefs.getString("name") ?? "";
  }

  static Future<void> setPassword(String password) async {
    await prefs.setString("password", password);
  }

  static String getPassword() {
    return prefs.getString("password") ?? "";
  }

  static Future<void> clear() async {
    await prefs.remove("email");
    await prefs.remove("password");
    await prefs.remove("name");
  }
}
