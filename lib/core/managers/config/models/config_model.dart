// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConfigModel {
  String uploadUrl;
  String headers;
  ConfigModel({
    required this.uploadUrl,
    required this.headers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uploadUrl': uploadUrl,
      'headers': headers,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      uploadUrl: map['uploadUrl'] as String,
      headers: map['headers'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
