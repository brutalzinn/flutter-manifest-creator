import 'package:flutter_manifest_creator/core/managers/config/models/config_model.dart';
import 'package:flutter_manifest_creator/core/progress/progress_bar_controller.dart';
import 'package:flutter_manifest_creator/operations/operations.dart';
import '../../../core/managers/config/config_manager.dart';

class HomeLogic {
  final progressController = ProgressBarController();

  Future<ConfigModel> loadConfig() async {
    var result = await ConfigManager.loadConfig();
    return result;
  }

  Future<void> saveConfig(ConfigModel config) async {
    await ConfigManager.saveConfig(config);
  }

  Future<void> upload(String modsDir) async {
    progressController.reset();
    progressController.setMaxProgress(5);
    progressController.setFeedback("Start ziping..");
    Operations.copyFilesFromTo(modsDir, "out",
        progressController: progressController);
  }
}
