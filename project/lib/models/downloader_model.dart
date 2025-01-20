import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/models/enum.dart';

class DownloaderModel with ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;
  DMStatus _status = DMStatus.pending;
  String _lastDownloadPath = '';
  Video? _lastVideo;

  int get counter => _counter;
  bool get isLoading => _isLoading;
  DMStatus get status => _status;
  Video? get lastVideo => _lastVideo;
  String get lastDownloadPath => _lastDownloadPath;

  void init() {
    _counter = 0;
    _isLoading = false;
    _status = DMStatus.pending;
    _lastDownloadPath = '';
    _lastVideo = null;
    notifyListeners();
  }

  void setSearching() {
    _status = DMStatus.searching;
    notifyListeners();
  }

  void setSearchingComplete() {
    _status = DMStatus.searchingComplete;
    notifyListeners();
  }

  void startLoading() {
    _isLoading = true;
    _status = DMStatus.downloading;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    _status = DMStatus.complete;
    notifyListeners();
  }

  void updateCount(int value, int max) {
    _counter = ((value * 100)/max).toInt() ;
    _status = DMStatus.downloading;
    notifyListeners();
  }

  void setLastDownloadPath(String path) {
    _lastDownloadPath = path;
    notifyListeners();
  }

  void setLastVideo(Video vid) {
    _lastVideo = vid;
    notifyListeners();
  }

}