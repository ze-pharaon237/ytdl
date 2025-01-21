import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

class FileService {
  static Future<String?> selectDirectoryPath({String? title}) async {
    var path = await FilePicker.platform
        .getDirectoryPath(dialogTitle: title ?? 'Select directory');
    return path;
  }

  static Future launchVideo(String path) async {
    return await OpenFile.open(path);
  }
}
