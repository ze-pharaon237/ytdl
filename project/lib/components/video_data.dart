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
    final theme = Theme.of(context); // Get the current theme

    return Consumer<DownloaderProvider>(
      builder: (context, provider, child) {
        if (provider.lastVideo == null) return const SizedBox.shrink();

        return ContainerShadowWidget(
          decorationColor: theme.colorScheme.surfaceVariant, // Adaptive background color
          child: provider.status == DownloaderStatus.searchingComplete
              ? _whenFind(provider, () => DownloaderService.download(provider))
              : _whenDownload(provider),
        );
      },
    );
  }

  Widget _whenFind(DownloaderProvider provider, AsyncCallback onPressed) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildThumbnail(provider, BoxFit.fitWidth, 250, double.infinity),
        const SizedBox(height: 10),
        Text('Title: ${provider.lastVideo!.title}', style: TextStyle(color: theme.colorScheme.onSurface)),
        Text(provider.lastVideo!.description, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        Text('Duration: ${provider.lastVideo!.duration}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        Text('Author: ${provider.lastVideo!.author}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        Text('Publish at: ${provider.lastVideo!.updateDate}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primaryContainer, // Ensures visibility across themes
          ),
          child: const Text('Download'),
        ),
      ],
    );
  }

  Widget _whenDownload(DownloaderProvider provider) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(provider.lastVideo!.title, style: TextStyle(color: theme.colorScheme.onSurface)),
          subtitle: Text(
            'Duration: ${provider.lastVideo!.duration}\nAuthor: ${provider.lastVideo!.author}',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
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
