import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/components/container_shadow.dart';
import 'package:yt_downloader/components/download_progress.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/models/enum.dart';
import 'package:yt_downloader/services/downloader_service.dart';

class VideoDataWidget extends StatefulWidget {
  const VideoDataWidget({super.key});

  @override
  State<VideoDataWidget> createState() => _VideoDataWidgetState();
}

class _VideoDataWidgetState extends State<VideoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DownloaderProvider>(
      builder: (context, provider, child) {
        if (provider.lastVideo == null) return const SizedBox.shrink();

        return ContainerShadowWidget(
          decorationColor: Colors.yellow.shade200,
          child: provider.status == DownloaderStatus.searchingComplete
              ? _whenFind(provider, () => DownloaderService.download(provider))
              : _whenDownload(provider),
        );
      },
    );
  }

  Widget _whenFind(DownloaderProvider provider, AsyncCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildThumbnail(provider, BoxFit.fitWidth, 250, double.infinity),
        const SizedBox(height: 10),
        Text('Title: ${provider.lastVideo!.title}'),
        Text(provider.lastVideo!.description),
        Text('Duration: ${provider.lastVideo!.duration}'),
        Text('Author: ${provider.lastVideo!.author}'),
        Text('Publish at: ${provider.lastVideo!.updateDate}'),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onPressed, child: const Text('Download')),
      ],
    );
  }

  Widget _whenDownload(DownloaderProvider provider) {
    return Column(
      children: [
        ListTile(
          title: Text(provider.lastVideo!.title),
          subtitle: Text('Duration: ${provider.lastVideo!.duration}\nAuthor: ${provider.lastVideo!.author}'),
          leading: SizedBox(
            height: 70,
            width: 70,
            child: _buildThumbnail(provider, BoxFit.cover, 70, 70),
          ),
          isThreeLine: true,
        ),
        const DownloadProgressWidget(),
      ],
    );
  }

  Widget _buildThumbnail(DownloaderProvider provider, BoxFit fit, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: provider.lastVideo!.thumbnail,
        fit: fit,
        height: height,
        width: width,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
