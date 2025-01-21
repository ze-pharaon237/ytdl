import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/models/downloader_model.dart';
import 'package:yt_downloader/models/enum.dart';
import 'package:yt_downloader/services/file_service.dart';

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({super.key});

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<DownloaderModel>();
    var counter = model.counter;
    var path = model.lastDownloadPath;
    var status = model.status;
    return Column(
      spacing: 10,
      children: [
        (status != DMStatus.downloading)
            ? Container()
            : LinearProgressIndicator(
                value: counter / 100,
                semanticsLabel: 'Download progress indicator',
              ),
        status != DMStatus.complete
            ? Container()
            : ElevatedButton(
                onPressed: () => FileService.launchVideo(path),
                child: Text('Play'))
      ],
    );
  }
}
