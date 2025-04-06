import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/local_storage_service.dart';

class SettingsService {
  // ignore: non_constant_identifier_names
  static final settingsKey_downloadDirPath = 'settings_downloadDirPath';

  static Future<String?> getDownloadDirectoryPath() async {
    return await LocalStorageService.getInstance()
        .loadString(settingsKey_downloadDirPath);
  }

  static Future<String?> askdownloadDirectoryPath({String? title}) async {
    var path = await FileService.selectDirectoryPath(title: title);
    if (path != null && path.isNotEmpty) {
      await setDownloadDirectoryPath(path);
    }
    return path;
  }

  static Future<String?> getOrAskdownloadDirectoryPath({String? title}) async {
    var path = await getDownloadDirectoryPath();
    if (path == null || path.isEmpty) {
      path = await askdownloadDirectoryPath(title: title);
    }
    return path;
  }

  static Future<void> setDownloadDirectoryPath(String path) async {
    await LocalStorageService.getInstance()
        .saveString(settingsKey_downloadDirPath, path);
  }
}
