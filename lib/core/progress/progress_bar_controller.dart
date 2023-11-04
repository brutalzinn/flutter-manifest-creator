import 'dart:convert';

import 'package:flutter/material.dart';

import 'progress.dart';

class ProgressBarController extends ChangeNotifier {
  num maxProgress = 0;
  num progress = 1;
  String feedback = "";
  double value = 0;
  bool? running;

  void done() {
    value = ((progress) /
        maxProgress); //Utils.remapper(progress.value + 0.1, 0, maxProgress, 0, 1); // its just percentage. dont need remap for this case.
    progress++;
    notifyListeners();
  }

  void reset() {
    maxProgress = 0;
    feedback = "";
    value = 0;
    notifyListeners();
  }

  void setMaxProgress(num max) {
    maxProgress = max;
  }

  void setFeedback(String msg) {
    feedback = msg;
    notifyListeners();
  }
}
