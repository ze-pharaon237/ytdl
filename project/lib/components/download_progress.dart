import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/models/enum.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/providers/video_provider.dart';

class DownloadProgressWidget extends StatefulWidget {
  const DownloadProgressWidget({super.key});

  @override
  State<DownloadProgressWidget> createState() => _DownloadProgressWidgetState();
}

class _DownloadProgressWidgetState extends State<DownloadProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DownloaderProvider>(
      builder: (context, provider, child) {
        if (provider.status.weight >= DownloaderStatus.downloading.weight) {
          return provider.status == DownloaderStatus.complete
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () => _resetState(context, provider),
                    child: Text(
                      'Nice',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Column(
                  children: [
                    LinearProgressIndicator(
                      value: provider.counter / 100,
                      semanticsLabel: 'Download progress indicator',
                    ),
                    SizedBox(height: 10),
                  ],
                );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _resetState(BuildContext context, DownloaderProvider provider) {
    Provider.of<VideoProvider>(context, listen: false).reloadVideos();
    provider.init();
  }
}
