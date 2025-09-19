import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/components/container_shadow.dart';
import 'package:yt_downloader/components/video_list_item.dart';
import 'package:yt_downloader/providers/video_provider.dart';

class VideosListWidget extends StatelessWidget {
  const VideosListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) => _buildVideosList(context, videoProvider.videos),
    );
  }

  Widget _buildVideosList(BuildContext context, List<FileSystemEntity> videos) {
    final theme = Theme.of(context); // Get the current theme

    if (videos.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Aucun fichier vidéo trouvé.",
              style: TextStyle(color: theme.textTheme.bodyLarge?.color), // Adaptive text color
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entity = videos[index];
          return ContainerShadowWidget(
            margin: 5,
            padding: 5,
            decorationColor: theme.colorScheme.surfaceContainerLow, // Adaptive background color
            child: VideoListItemWidget(entity: entity),
          );
        },
        childCount: videos.length,
      ),
    );
  }
}
