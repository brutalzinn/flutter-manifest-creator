import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';
import 'package:flutter_manifest_creator/core/resources.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_elevated_button.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_input_text.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_progress_bar.dart';
import 'package:flutter_manifest_creator/modules/config/config.dart';

import 'logic/home_logic.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({super.key});
  HomeLogic homeLogic = HomeLogic();

  @override
  _ManifestCreatorState createState() => _ManifestCreatorState();
}

class _ManifestCreatorState extends State<Home> {
  TextEditingController manifestUrlController = TextEditingController();
  TextEditingController ignoreFolderController = TextEditingController();
  TextEditingController outputDirController = TextEditingController();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var config = await widget.homeLogic.loadConfig();
    //   outputDirController.text = config.outputDir;
    //   manifestUrlController.text = config.manifestURL;
    //   ignoreFolderController.text = config.ignoreFolders;
    // });

    super.initState();
    widget.homeLogic.progressController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Resources.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(children: [
                CustomElevatedButton(
                  label: 'Config',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Config()),
                    );
                  },
                )
              ]),
              CustomElevatedButton(
                  onPressed: () async {
                    var folder = await FilePicker.platform.getDirectoryPath();
                    if (folder != null) {
                      outputDirController.text = folder;
                    }
                  },
                  label: 'Select the mods folder'),
              const SizedBox(height: 20.0),
              Text(
                'Mods folder: ${outputDirController.text}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.homeLogic.progressController.feedback ?? "",
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              CustomProgressBar(
                  value: widget.homeLogic.progressController.value),
              const SizedBox(height: 20.0),
              CustomElevatedButton(
                label: 'Upload',
                onPressed: () {
                  widget.homeLogic.upload(outputDirController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
