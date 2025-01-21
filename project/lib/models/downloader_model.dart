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
    _updateState(
      counter: 0,
      isLoading: false,
      status: DMStatus.pending,
      lastDownloadPath: '',
      lastVideo: null,
    );
  }

  void setStatusSearching() => _updateState(status: DMStatus.searching);
  void setStatusSearchingComplete() => _updateState(status: DMStatus.searchingComplete);
  void setStatusCreateStream() => _updateState(status: DMStatus.createStream);
  void setStatusCheckDestinationDir() => _updateState(status: DMStatus.checkDestinationDir);
  void setStatusComplete() => _updateState(status: DMStatus.complete);
  void setStatusFailed() => _updateState(status: DMStatus.failed);

  void startLoading() => _updateState(isLoading: true);
  void stopLoading() => _updateState(isLoading: false);

  void updateDownloadCounter(int value, int max) {
    _counter = ((value * 100) / max).toInt();
    _updateState(status: DMStatus.downloading);
  }

  void setLastDownloadPath(String path) => _updateState(lastDownloadPath: path);
  void setLastVideo(Video vid) => _updateState(lastVideo: vid);

  void _updateState({
    int? counter,
    bool? isLoading,
    DMStatus? status,
    String? lastDownloadPath,
    Video? lastVideo,
  }) {
    _counter = counter ?? _counter;
    _isLoading = isLoading ?? _isLoading;
    _status = status ?? _status;
    _lastDownloadPath = lastDownloadPath ?? _lastDownloadPath;
    _lastVideo = lastVideo ?? _lastVideo;
    notifyListeners();
  }
}
