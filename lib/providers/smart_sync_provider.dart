import 'package:flutter/material.dart';

class SmartSyncPreferences extends ChangeNotifier {
  bool isEnabled = true;
  bool downloadCurrentClass = true;
  bool downloadUpcomingClass = true;
  bool downloadPreviousClass = false;

  bool keepLecture = true;
  bool keepPresentation = false;
  bool keepSeminar = false;
  bool keepQuiz = false;
  bool keepOther = false;

  void toggleEnabled(bool value) {
    isEnabled = value;
    if (!value) {
      _uncheckAll();
    }
    notifyListeners();
  }

  void _uncheckAll() {
    downloadCurrentClass = false;
    downloadUpcomingClass = false;
    downloadPreviousClass = false;
    keepLecture = false;
    keepPresentation = false;
    keepSeminar = false;
    keepQuiz = false;
    keepOther = false;
  }

  bool _anyChecked() {
    return downloadCurrentClass ||
        downloadUpcomingClass ||
        downloadPreviousClass ||
        keepLecture ||
        keepPresentation ||
        keepSeminar ||
        keepQuiz ||
        keepOther;
  }

  void _checkAutoDisable() {
    if (!_anyChecked()) {
      isEnabled = false;
    } else if (!isEnabled) {
      isEnabled = true;
    }
  }

  void toggleDownloadPref(String key, bool value) {
    switch (key) {
      case 'current': downloadCurrentClass = value; break;
      case 'upcoming': downloadUpcomingClass = value; break;
      case 'previous': downloadPreviousClass = value; break;
    }
    _checkAutoDisable();
    notifyListeners();
  }

  void toggleFileType(String key, bool value) {
    switch (key) {
      case 'lecture': keepLecture = value; break;
      case 'presentation': keepPresentation = value; break;
      case 'seminar': keepSeminar = value; break;
      case 'quiz': keepQuiz = value; break;
      case 'other': keepOther = value; break;
    }
    _checkAutoDisable();
    notifyListeners();
  }
}
