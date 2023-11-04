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
    _calculateProgress();
    notifyListeners();
  }

  void complete() {
    progress = maxProgress;
    _calculateProgress();
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

  void _calculateProgress() {
    value = ((progress) / maxProgress);
    progress++;
  }
}
