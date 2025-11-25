import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesService {
  const SharedPreferencesService._(SharedPreferences prefs) : _prefs = prefs;

  final SharedPreferences _prefs;

  static Future<SharedPreferencesService> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return SharedPreferencesService._(preferences);
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, {required bool value}) {
    return _prefs.setBool(key, value);
  }

  Object? getString(String key) => _prefs.get(key);

  bool? hasKey(String key) => _prefs.containsKey(key);

  Future<bool> clearAll() => _prefs.clear();

  Future<bool> removeKey(String key) => _prefs.remove(key);
}
