import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/models/enum.dart';

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({super.key});

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DownloaderProvider>();
    var counter = provider.counter;
    var status = provider.status;
    return Column(
      spacing: 10,
      children: [
        (status != DownloaderStatus.downloading)
            ? Container()
            : LinearProgressIndicator(
                value: counter / 100,
                semanticsLabel: 'Download progress indicator',
              ),
      ],
    );
  }
}
