import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yt_downloader/components/video_delete_dialog.dart';
import 'package:yt_downloader/providers/video_provider.dart';
import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/local_videos_service.dart';

class VideoListItemWidget extends StatefulWidget {
  final FileSystemEntity entity;

  const VideoListItemWidget({super.key, required this.entity});

  @override
  State<VideoListItemWidget> createState() => _VideoListItemWidgetState();
}

class _VideoListItemWidgetState extends State<VideoListItemWidget> {
  File? _thumbnail;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final thumbnail = await LocalVideoService.getVideoThumbnail(widget.entity);
    setState(() {
      _thumbnail = thumbnail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return ListTile(
      title: Text(
        basename(widget.entity.path),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color, // Adaptive text color
        ),
      ),
      subtitle: Text(
        'Taille: ${(widget.entity.statSync().size / 1000 / 1000).toStringAsFixed(2)} Mo',
        style: TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodySmall?.color, // Adaptive subtitle color
        ),
      ),
      leading: _buildThumbnail(),
      trailing: _buildActionButtons(context, theme),
      onTap: () => FileService.launchVideo(widget.entity.path),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildThumbnail() {
    if (_thumbnail != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_thumbnail!, height: 70, width: 70, fit: BoxFit.cover),
      );
    }
    return const SizedBox(
      height: 70,
      width: 70,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.share, color: theme.iconTheme.color), // Adaptive icon color
          onPressed: () => _share(),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: theme.colorScheme.error), // Adaptive delete color
          onPressed: () => VideoDeleteDialog.show(
            context,
            widget.entity,
            Provider.of<VideoProvider>(context, listen: false).reloadVideos,
          ),
        ),
      ],
    );
  }

  void _share() {
    final params = ShareParams(
      title: "Share video: ${basename(widget.entity.path)}",
      files: [XFile(widget.entity.path)],
    );
    SharePlus.instance.share(params);
  }
}
