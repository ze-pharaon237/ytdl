import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/models/downloader_model.dart';
import 'package:yt_downloader/models/enum.dart';

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({super.key});

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  void launchVideo(String path) async {
    var result = await OpenFile.open(path);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  }

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
                onPressed: () => launchVideo(path), child: Text('Play'))
      ],
    );
  }
}
