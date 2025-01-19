import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:yt_downloader/utils/downloader.dart';

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
      setState(() {
        _linkController.text = value.first.value!;
      });
    });
  }

  Future<void> onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process data.
      
      try {
        var result = Downloader(_linkController.text);
        result = await result.getMetadata();
        var path = await result.download();
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text(path))
        );
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text("Téléchargement terminé"))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text(e.toString()))
        );
      }
      // print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _linkController,
            decoration: InputDecoration(labelText: 'Entrer or paste the youtube link'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This can\'t be empty';
              }
              return null;
            }, 
          ),
          ElevatedButton(
            onPressed: onFormSubmit, 
            child: const Text('Download')
          )
        ],
      ),
    );
  }
}