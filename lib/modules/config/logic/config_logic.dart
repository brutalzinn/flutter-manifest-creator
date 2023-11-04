import 'package:flutter_manifest_creator/core/managers/config/config_manager.dart';
import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';

class ConfigLogic {
  Future<ConfigModel> loadConfig() async {
    var result = await ConfigManager.loadConfig();
    return result;
  }

  Future<void> saveConfig(ConfigModel config) async {
    await ConfigManager.saveConfig(config);
  }
}
