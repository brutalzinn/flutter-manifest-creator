import 'package:flutter_manifest_creator/core/managers/config/config_manager.dart';
import 'package:flutter_manifest_creator/core/progress/progress_bar_controller.dart';
import 'package:flutter_manifest_creator/operations/operations.dart';

class HomeLogic {
  final progressController = ProgressBarController();

  Future<void> upload(String modsDir) async {
    final finalZipPath = "to_upload.zip";
    final filesDir = "out";
    await Operations.copyFilesFromTo(modsDir, "out",
        progressController: progressController);
    await Operations.createZip(filesDir, finalZipPath,
        progressController: progressController);
    progressController.setFeedback("Loading config pre setup.");
    final config = await ConfigManager.loadConfig();
    final headersText = config.headers.split(";");
    Map<String, String> headers = {};
    for (String header in headersText) {
      final headerSplit = header.split("=");
      final key = headerSplit[0];
      final value = headerSplit[1];
      headers[key] = value;
    }
    progressController.setFeedback("Starting uploading..");
    await Operations.uploadFile(finalZipPath, config.uploadUrl,
        headers: headers);
  }
}
