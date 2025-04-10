import 'package:flutter/material.dart';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/models/enum.dart';

class DownloaderProvider with ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;
  DownloaderStatus _status = DownloaderStatus.pending;
  String _lastDownloadPath = '';
  CommonVideo? _lastVideo;

  int get counter => _counter;
  bool get isLoading => _isLoading;
  DownloaderStatus get status => _status;
  CommonVideo? get lastVideo => _lastVideo;
  String get lastDownloadPath => _lastDownloadPath;

  void init({CommonVideo? video}) {
    _updateState(
      counter: 0,
      isLoading: false,
      status: DownloaderStatus.pending,
      lastDownloadPath: '',
      lastVideo: video,
    );
  }

  void setStatusSearching() => _updateState(status: DownloaderStatus.searching);
  void setStatusSearchingComplete() => _updateState(status: DownloaderStatus.searchingComplete);
  void setStatusCreateStream() => _updateState(status: DownloaderStatus.createStream);
  void setStatusCheckDestinationDir() => _updateState(status: DownloaderStatus.checkDestinationDir);
  void setStatusComplete() => _updateState(status: DownloaderStatus.complete);
  void setStatusFailed() => _updateState(status: DownloaderStatus.failed);

  void startLoading() => _updateState(isLoading: true);
  void stopLoading() => _updateState(isLoading: false);

  void updateDownloadCounter(int value, int max) {
    _counter = ((value * 100) / max).toInt();
    _updateState(status: DownloaderStatus.downloading);
  }

  void setLastDownloadPath(String path) => _updateState(lastDownloadPath: path);
  void setLastVideo(CommonVideo vid) => _updateState(lastVideo: vid);

  void _updateState({
    int? counter,
    bool? isLoading,
    DownloaderStatus? status,
    String? lastDownloadPath,
    CommonVideo? lastVideo,
  }) {
    _counter = counter ?? _counter;
    _isLoading = isLoading ?? _isLoading;
    _status = status ?? _status;
    _lastDownloadPath = lastDownloadPath ?? _lastDownloadPath;
    _lastVideo = lastVideo ?? _lastVideo;
    notifyListeners();
  }
}
