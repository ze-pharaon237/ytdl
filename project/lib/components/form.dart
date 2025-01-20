import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/models/downloader_model.dart';
import 'package:yt_downloader/utils/downloader.dart';

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
      });
    });
    FlutterSharingIntent.instance.getInitialSharing().then((value) {
      if (value.firstOrNull != null) {
        setState(() {
          _linkController.text = value.first.value!;
        });
      }
    });
  }

  Future<void> onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process data.
      
      try {
        var model = Provider.of<DownloaderModel>(context, listen: false);
        var result = await Downloader(model, _linkController.text).getMetadata();
        model.setLastVideo(result);
        
        // var path = await result.download();
        // ScaffoldMessenger.of(context).showSnackBar( 
        //   SnackBar(content: Text(path))
        // );
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text('Find: ${result.title}'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text(e.toString()))
        );
      }

      // var model = Provider.of<DownloaderModel>(context, listen: false); 
      // model.updateCount(model.counter + 1, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    var downloaderModel = context.watch<DownloaderModel>();
    var isLoading = downloaderModel.isLoading;
    var status = downloaderModel.status;

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
          ElevatedButton(
            onPressed: isLoading ? null : onFormSubmit,
            child: Text('Find')
          ),
          Text(status.toString())
        ],
      ),
    );
  }
}