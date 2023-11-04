class ConfigModel {
  String manifestURL;
  String outputDir;
  String ignoreFolders;

  ConfigModel({
    required this.manifestURL,
    required this.outputDir,
    required this.ignoreFolders,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      manifestURL: json['manifest_url'],
      outputDir: json['output_dir'],
      ignoreFolders: json['ignore_folders'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manifest_url': manifestURL,
      'output_dir': outputDir,
      'ignore_folders': ignoreFolders,
    };
  }
}
