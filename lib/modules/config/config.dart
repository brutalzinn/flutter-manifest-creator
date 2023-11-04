import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';
import 'package:flutter_manifest_creator/core/resources.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_elevated_button.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_input_text.dart';
import 'package:flutter_manifest_creator/core/ui/widgets/custom_progress_bar.dart';
import 'package:flutter_manifest_creator/modules/config/logic/config_logic.dart';

// ignore: must_be_immutable
class Config extends StatefulWidget {
  Config({super.key});
  ConfigLogic configLogic = ConfigLogic();

  @override
  _ConfigManifestCreatorAppState createState() =>
      _ConfigManifestCreatorAppState();
}

class _ConfigManifestCreatorAppState extends State<Config> {
  TextEditingController headersTextEditingController = TextEditingController();
  TextEditingController uploadUrlTextEditingController =
      TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var config = await widget.configLogic.loadConfig();
      headersTextEditingController.text = config.headers;
      uploadUrlTextEditingController.text = config.uploadUrl;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                CustomInputText(
                  controller: uploadUrlTextEditingController,
                  label: 'Upload url:',
                ),
                CustomInputText(
                  controller: headersTextEditingController,
                  label: 'Headers (separe using ;)',
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  label: 'Save',
                  onPressed: () {
                    final config = ConfigModel(
                        uploadUrl: uploadUrlTextEditingController.text,
                        headers: headersTextEditingController.text);
                    widget.configLogic.saveConfig(config);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  label: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
