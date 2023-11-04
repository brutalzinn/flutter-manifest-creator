import 'package:flutter/material.dart';
import 'package:flutter_manifest_creator/modules/home/home.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const defaultMain = ManifestCreatorApp();
  await windowManager.ensureInitialized();
  WindowManager.instance.setMaximumSize(const Size(800, 800));
  runApp(defaultMain);
}

class ManifestCreatorApp extends StatelessWidget {
  const ManifestCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}
