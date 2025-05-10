import 'package:flutter/material.dart';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/models/enum.dart';

class DownloaderProvider with ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;
  DownloaderStatus _status = DownloaderStatus.pending;
  String _lastDownloadPath = '';
  CommonVideo? _lastVideo;
  String _statusDetail = '';

  int get counter => _counter;
  bool get isLoading => _isLoading;
  DownloaderStatus get status => _status;
  String get statusDetail => _statusDetail;
  CommonVideo? get lastVideo => _lastVideo;
  String get lastDownloadPath => _lastDownloadPath;

  void init() {
    _lastVideo = null;
    _lastDownloadPath = "";
    _updateState(
      counter: 0,
      isLoading: false,
      status: DownloaderStatus.pending,
      statusDetail: '',
    );
  }

  void setStatusSearching() => _updateState(status: DownloaderStatus.searching);
  void setStatusSearchingComplete() => _updateState(status: DownloaderStatus.searchingComplete);
  void setStatusCheckDestinationDir() => _updateState(status: DownloaderStatus.checkDestinationDir);
  void setStatusGetVideo() => _updateState(status: DownloaderStatus.getVideo);
  void setStatusDownloading() => _updateState(status: DownloaderStatus.downloading);
  void setStatusComplete() => _updateState(status: DownloaderStatus.complete);
  void setStatusFailed() => _updateState(status: DownloaderStatus.failed);

  void setStatusDetail(String detail) => _updateState(statusDetail: detail);

  void startLoading() => _updateState(isLoading: true);
  void stopLoading() => _updateState(isLoading: false);

  void updateDownloadCounter(int value, int max) {
    _counter = ((value * 100) / max).toInt();
    _updateState(status: DownloaderStatus.downloading);
  }

  void setLastDownloadPath(String path) {
    _lastDownloadPath = path;
    notifyListeners();
  }

  void setLastVideo(CommonVideo vid) {
    _lastVideo = vid;
    notifyListeners();
  }

  void _updateState({
    int? counter,
    bool? isLoading,
    DownloaderStatus? status,
    String? statusDetail,
  }) {
    _counter = counter ?? _counter;
    _isLoading = isLoading ?? _isLoading;
    _status = status ?? _status;
    _statusDetail = status != null ? status.message : statusDetail ?? _statusDetail;
    notifyListeners();
  }
}
