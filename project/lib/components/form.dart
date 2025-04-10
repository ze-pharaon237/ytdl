import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
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
  int cpt = 0;

  @override
  void dispose() {
    _linkController.dispose(); // Dispose the controller when it's no longer needed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FlutterSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        _linkController.text = value.first.value!;
        onFormSubmit();
      });
    });
    FlutterSharingIntent.instance.getInitialSharing().then((value) {
      if (value.firstOrNull != null) {
        setState(() {
          _linkController.text = value.first.value!;
          onFormSubmit();
        });
      }
    });
  }

  Future<void> onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process data.

      try {
        final provider = Provider.of<DownloaderProvider>(context, listen: false);
        final result = await DownloaderService.find(_linkController.text, provider);
        provider.setLastVideo(result);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Find: ${result.title}')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var downloaderProvider = context.watch<DownloaderProvider>();
    var isLoading = downloaderProvider.isLoading;
    var status = downloaderProvider.status;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _linkController,
            decoration: InputDecoration(labelText: 'Entrer or paste the youtube link'),
            enabled: !isLoading,
            autofocus: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This can\'t be empty';
              }
              return null;
            },
          ),
          ElevatedButton(onPressed: isLoading ? null : onFormSubmit, child: Text('Find')),
          Text(status.toString())
        ],
      ),
    );
  }
}
