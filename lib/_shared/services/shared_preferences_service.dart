import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesService {
  const SharedPreferencesService._(SharedPreferences prefs) : _prefs = prefs;

  final SharedPreferences _prefs;

  static Future<SharedPreferencesService> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return SharedPreferencesService._(preferences);
  }

  Future<bool> write(String key, String value) => _prefs.setString(key, value);

  Object? getString(String key) => _prefs.get(key);

  bool? hasKey(String key) => _prefs.containsKey(key);
}
