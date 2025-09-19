import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/services/downloader_service.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _handleSharingIntent();
  }

  void _handleSharingIntent() {
    FlutterSharingIntent.instance.getMediaStream().listen(_processSharedIntent);
    FlutterSharingIntent.instance.getInitialSharing().then(_processSharedIntent);
  }

  void _processSharedIntent(List<SharedFile> value) {
    if (value.isNotEmpty && value.first.value != null && value.first.value!.isNotEmpty) {
      setState(() {
        _linkController.text = value.first.value!.trim();
      });
      onFormSubmit();
    }
  }

  Future<void> onFormSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<DownloaderProvider>(context, listen: false);
    try {
      final result = await DownloaderService.find(_linkController.text.trim(), provider);
      provider.setLastVideo(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Find: ${result.title}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    final downloaderProvider = context.watch<DownloaderProvider>();
    final isLoading = downloaderProvider.isLoading;
    final status = downloaderProvider.status;
    final statusDetail = downloaderProvider.statusDetail;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: 'Enter or paste the YouTube/tiktok link',
                      labelStyle: TextStyle(color: theme.textTheme.bodyLarge?.color), // Adaptive label color
                      prefixIcon: Icon(Icons.link, color: theme.iconTheme.color), // Adaptive icon color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                      ),
                      suffixIcon: _linkController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: theme.colorScheme.error), // Adaptive clear button color
                              onPressed: () => setState(() => _linkController.clear()),
                            )
                          : null,
                    ),
                    enabled: !isLoading,
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'This can\'t be empty' : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : onFormSubmit, // Adaptive button icon
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Icon(Icons.search, size: 20, color: theme.iconTheme.color),
                )
              ],
            ),
            Text(
              status.message,
              style: TextStyle(fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color),
            ),
            if (statusDetail != status.message)
              Text(
                statusDetail,
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
          ],
        ),
      ),
    );
  }
}
