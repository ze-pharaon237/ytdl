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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Find: ${result.title}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloaderProvider = context.watch<DownloaderProvider>();
    final isLoading = downloaderProvider.isLoading;
    final status = downloaderProvider.status;
    final statusDetail = downloaderProvider.statusDetail;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          TextFormField(
            controller: _linkController,
            decoration: InputDecoration(
              labelText: 'Enter or paste the YouTube link',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: _linkController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.redAccent),
                      onPressed: () => setState(() => _linkController.clear()),
                    )
                  : null,
            ),
            enabled: !isLoading,
            autofocus: true,
            validator: (value) => (value == null || value.trim().isEmpty) ? 'This can\'t be empty' : null,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onFormSubmit,
              icon: const Icon(Icons.search, size: 20),
              label: const Text('Find'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            status.message,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          if (statusDetail != status.message)
            Text(
              statusDetail,
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
