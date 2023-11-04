import 'dart:convert';
import 'dart:io';

import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';


class ConfigManager {
  static const String configFilePath = 'config.json';
  static Future<ConfigModel> loadConfig() async {
    try {
      File file = File(configFilePath);
      String contents = await file.readAsString();
      Map<String, dynamic> jsonData = json.decode(contents);
      return ConfigModel.fromJson(jsonData);
    } catch (e) {
      return ConfigModel(
          manifestURL: '',
          outputDir: '',
          ignoreFolders:
              'libraries/**,assets/**,config/**,logs/**, loader/**,versions/**,tlauncher_libraries/**,server-resource-packs/**,runtime/**,backup/**,options.txt,servers.dat,TL**,worlds.json');
    }
  }

  static Future<void> saveConfig(ConfigModel configModel) async {
    File file = File(configFilePath);
    await file.writeAsString(jsonEncode(configModel));
  }
}
