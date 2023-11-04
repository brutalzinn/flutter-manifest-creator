class FileModel {
  String name;
  String path;
  String url;
  String hash;

  FileModel(
      {required this.name,
      required this.path,
      required this.url,
      required this.hash});

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      name: json['name'],
      path: json['path'],
      url: json['url'],
      hash: json['hash'],
    );
  }
}
