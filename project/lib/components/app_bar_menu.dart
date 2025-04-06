import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yt_downloader/services/settings_service.dart';

class AppBarMenuWidget extends StatelessWidget {
  const AppBarMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem<AsyncCallback>(
          value: () => SettingsService.askdownloadDirectoryPath(
              title: 'Select destination directory'),
          child: const Text('Change destination'),
        )
      ],
      onSelected: (fn) async => await fn(),
    );
  }
}
