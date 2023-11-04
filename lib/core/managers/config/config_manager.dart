import 'dart:convert';
import 'dart:io';

import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';

class ConfigManager {
  static const String configFilePath = 'config.json';
  static Future<ConfigModel> loadConfig() async {
    try {
      File file = File(configFilePath);
      String contents = await file.readAsString();
      return ConfigModel.fromJson(contents);
    } catch (e) {
      return ConfigModel(
          uploadUrl: 'http://example', headers: "api-key=1234;otherheader=123");
    }
  }

  static Future<void> saveConfig(ConfigModel configModel) async {
    File file = File(configFilePath);
    await file.writeAsString(configModel.toJson());
  }
}
