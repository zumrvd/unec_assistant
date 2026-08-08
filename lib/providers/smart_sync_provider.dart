import 'package:flutter/material.dart';

class SmartSyncPreferences extends ChangeNotifier {
  bool _isEnabled = false;

  bool _downloadCurrentClass = false;
  bool _downloadUpcomingClass = false;
  bool _downloadPreviousClass = false;

  bool _downloadLecture = false;
  bool _downloadPresentation = false;
  bool _downloadSeminar = false;
  bool _downloadOther = false;

  bool _savedCurrentClass = true;
  bool _savedUpcomingClass = false;
  bool _savedPreviousClass = false;

  bool _savedLecture = true;
  bool _savedPresentation = true;
  bool _savedSeminar = true;
  bool _savedOther = false;

  bool get isEnabled => _isEnabled;
  bool get downloadCurrentClass => _downloadCurrentClass;
  bool get downloadUpcomingClass => _downloadUpcomingClass;
  bool get downloadPreviousClass => _downloadPreviousClass;
  bool get downloadLecture => _downloadLecture;
  bool get downloadPresentation => _downloadPresentation;
  bool get downloadSeminar => _downloadSeminar;
  bool get downloadOther => _downloadOther;

  void toggleEnabled(bool value) {
    _isEnabled = value;

    if (_isEnabled) {
      _downloadCurrentClass = _savedCurrentClass;
      _downloadUpcomingClass = _savedUpcomingClass;
      _downloadPreviousClass = _savedPreviousClass;
      _downloadLecture = _savedLecture;
      _downloadPresentation = _savedPresentation;
      _downloadSeminar = _savedSeminar;
      _downloadOther = _savedOther;

      if (!_isValidSelection()) {
        _setDefaults();
      }
    } else {
      _clearAllSelections();
    }
    notifyListeners();
  }

  void updateCurrentClass(bool value) {
    _downloadCurrentClass = value;
    _checkAutoCloseOrSave();
  }
  void updateUpcomingClass(bool value) { _downloadUpcomingClass = value; _checkAutoCloseOrSave(); }
  void updatePreviousClass(bool value) { _downloadPreviousClass = value; _checkAutoCloseOrSave(); }
  void updateLecture(bool value) { _downloadLecture = value; _checkAutoCloseOrSave(); }
  void updatePresentation(bool value) { _downloadPresentation = value; _checkAutoCloseOrSave(); }
  void updateSeminar(bool value) { _downloadSeminar = value; _checkAutoCloseOrSave(); }
  void updateOther(bool value) { _downloadOther = value; _checkAutoCloseOrSave(); }

  bool _hasTimingSelection() {
    return _downloadCurrentClass || _downloadUpcomingClass || _downloadPreviousClass;
  }

  bool _hasTypeSelection() {
    return _downloadLecture || _downloadPresentation || _downloadSeminar || _downloadOther;
  }

  bool _isValidSelection() {
    return _hasTimingSelection() && _hasTypeSelection();
  }

  void _setDefaults() {
    _downloadCurrentClass = true;
    _downloadLecture = true;
    _downloadPresentation = true;
    _downloadSeminar = true;
    _saveCurrentState();
  }

  void _saveCurrentState() {
    _savedCurrentClass = _downloadCurrentClass;
    _savedUpcomingClass = _downloadUpcomingClass;
    _savedPreviousClass = _downloadPreviousClass;
    _savedLecture = _downloadLecture;
    _savedPresentation = _downloadPresentation;
    _savedSeminar = _downloadSeminar;
    _savedOther = _downloadOther;
  }

  void _clearAllSelections() {
    _downloadCurrentClass = false;
    _downloadUpcomingClass = false;
    _downloadPreviousClass = false;
    _downloadLecture = false;
    _downloadPresentation = false;
    _downloadSeminar = false;
    _downloadOther = false;
  }

  void _checkAutoCloseOrSave() {
    if (!_isValidSelection()) {
      _isEnabled = false;
      _clearAllSelections();
    } else {
      _saveCurrentState();
    }
    notifyListeners();
  }
}
