import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  static _LocalStorageImpl? _instance;

  Future<bool> saveString(String key, String value);
  Future<String?> loadString(String key);

  static LocalStorageService getInstance() {
    _instance ??= _LocalStorageImpl();
    return _instance!;
  }
}

class _LocalStorageImpl implements LocalStorageService {
  SharedPreferences? _store;

  Future<SharedPreferences> _getStore() async {
    return _store ??= await SharedPreferences.getInstance();
  }

  @override
  Future<bool> saveString(String key, String value) async {
    return await ((await _getStore()).setString(key, value));
  }

  @override
  Future<String?> loadString(String key) async {
    return (await _getStore()).getString(key);
  }
}
