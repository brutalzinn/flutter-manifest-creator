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
      progressController.setFeedback("Copying mods to out dir.");
      progressController.setMaxProgress(files.length);
    }
    for (var file in files) {
      final filename = path.basename(file.path);
      if (file is Directory) {
        final dirName = path.join(toDir, filename);
        await Directory(dirName).create(recursive: true);
        continue;
      }
      final relativePath = path.relative(file.path, from: fromDir);
      final outputPath = path.join(toDir, relativePath);
      await File(file.path).copy(outputPath);
      if (useProgress) {
        progressController.setFeedback("copying $filename to $toDir");
        progressController.done();
      }
    }
  }

  static Future<void> createZip(String inputDir, String outputZipDir,
      {ProgressBarController? progressController}) async {
    final useProgress = progressController != null;
    // var files = Directory(inputDir).listSync(recursive: true);
    if (useProgress) {
      progressController.setFeedback("Starting ziping out dir..");
      progressController.setMaxProgress(100);
    }
    var encoder = ZipFileEncoder();
    final directory = Directory(inputDir);
    encoder.zipDirectory(directory, filename: outputZipDir, onProgress: (p0) {
      if (useProgress) progressController.done();
    });
    if (useProgress) progressController.complete();
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

  static Future<void> uploadFile(String filePath, String uploadUrl,
      {Map<String, String>? headers,
      ProgressBarController? progressController}) async {
    final useProgress = progressController != null;
    if (useProgress) {
      progressController.reset();
      progressController.setFeedback("Prepare for uploading..");
    }
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      if (headers != null) {
        request.headers.addAll(headers);
      }
      var file = await http.MultipartFile.fromPath('file', filePath,
          filename: 'file.zip');
      request.files.add(file);
      var response = await request.send();
      if (response.statusCode == 201) {
        print('File uploaded successfully');
        if (useProgress) {
          progressController.complete();
          progressController.setFeedback("File uploaded successfully");
        }
      } else {
        if (useProgress) {
          progressController.setFeedback(
              'Failed to upload file. Status code: ${response.statusCode}');
          progressController.complete();
        }
        throw Exception(
            'Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      if (useProgress) {
        progressController.setFeedback('Error uploading file: $error');
        progressController.complete();
      }
      throw Exception('Error uploading file: $error');
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
