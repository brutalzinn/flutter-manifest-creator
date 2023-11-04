import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter_manifest_creator/core/progress/progress.dart';
import 'package:flutter_manifest_creator/core/progress/progress_bar_controller.dart';
import 'package:glob/glob.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'models/file_model.dart';
import 'package:path/path.dart' as path;

typedef CallbackProgress = void Function(ProgressModel);

class Operations {
  static Future<List<FileModel>> readManifestFiles(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<FileModel>.from(
          list.map((model) => FileModel.fromJson(model)));
    } else {
      throw Exception('Failed to fetch manifest');
    }
  }

  static Future<void> copyFilesFromTo(String fromDir, String toDir,
      {bool createDir = true,
      ProgressBarController? progressController}) async {
    final useProgress = progressController != null;
    if (createDir) {
      await Directory(toDir).create();
    }
    var files = Directory(fromDir).listSync(recursive: true);
    if (useProgress) {
      progressController.setMaxProgress(files.length);
    }
    for (var file in files) {
      var outFilePath = '$toDir/${file.path}';
      await File(file.path).copy(outFilePath);
      if (useProgress) {
        progressController.done();
      }
    }
  }

  static Future<void> createZip(String inputDir, String outputZipDir) async {
    var files = Directory(inputDir).listSync(recursive: true);
    var encoder = ZipFileEncoder();
    encoder.create(path.join(outputZipDir, "output.zip"));
    for (var file in files) {
      await encoder.addFile(File(file.path));
    }
    encoder.close();
  }

  static Future<void> downloadFile(FileModel file, String outputDir) async {
    var outFilePath = '$outputDir/${file.path}';
    var dirName = File(outFilePath).parent.path;
    await Directory(dirName).create(recursive: true);
    var outFile = File(outFilePath).openWrite();
    var response = await http.get(Uri.parse(file.url));
    if (response.statusCode == 200) {
      var controller = StreamController<List<int>>();
      controller.sink.add(response.bodyBytes);
      controller.stream.pipe(outFile);
      await controller.close();
      await outFile.close();
    } else {
      throw Exception('Failed to download file: ${file.name}');
    }
  }

  static Future<void> cleanupOutputDir(
      List<FileModel> manifestFiles,
      String outputDir,
      List<String> ignoredItems,
      CallbackProgress callbackAction) async {
    final progress = ProgressModel();
    var files = Directory(outputDir).listSync(recursive: true);
    var manifestFileSet = {
      for (var file in manifestFiles) file.path: file.hash
    };
    for (var file in files) {
      progress.setFeedback("verify ${file.parent.path}");
      callbackAction(progress);

      var fileWithoutPathSeparator =
          file.path.replaceAll(Platform.pathSeparator, "/");

      var relativePath =
          fileWithoutPathSeparator.substring(outputDir.length + 1);

      final isToIgnore = shouldIgnore(relativePath, ignoredItems);
      if (isToIgnore || file is Directory) {
        progress.setFeedback("ignore $fileWithoutPathSeparator");
        callbackAction(progress);
        continue;
      }
      final hash = await calculateFileHash(file.path);
      final isDiff = manifestFileSet[relativePath] != hash;
      final isAtManifest = manifestFileSet.containsKey(relativePath);
      if (!isAtManifest || isDiff) {
        await file.delete();
        progress.setFeedback("delete ${file.parent.path}");
        callbackAction(progress);
      }
    }
  }

  static Future<String> calculateFileHash(String filePath) async {
    var file = File(filePath);
    var contents = await file.readAsBytes();
    var digest = sha1.convert(contents);
    return digest.toString();
  }

  static bool shouldIgnore(String item, List<String> ignoredItems) {
    for (String pattern in ignoredItems) {
      if (Glob(pattern).matches(item)) {
        return true;
      }
    }
    return false;
  }
}
