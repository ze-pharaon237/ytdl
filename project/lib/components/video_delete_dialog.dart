import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yt_downloader/services/file_service.dart';

class VideoDeleteDialog {
  static void show(BuildContext context, FileSystemEntity entity, VoidCallback onDeleteSuccess) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: Text('Are you sure you want to remove this file: ${entity.path}?'),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  FileService.deleteVideo(entity.path);
                  onDeleteSuccess(); // Actualiser la liste après suppression
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}