import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yt_downloader/services/local_videos_service.dart';

class VideoProvider with ChangeNotifier {
  List<FileSystemEntity> _videos = [];

  List<FileSystemEntity> get videos => _videos;

  VideoProvider() {
    reloadVideos();
  }

  Future<void> reloadVideos() async {
    _videos = await LocalVideoService.loadFromFolder();
    notifyListeners();
  }
}
