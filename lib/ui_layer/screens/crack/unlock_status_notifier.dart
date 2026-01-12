import 'package:flutter/material.dart';

class UnlockStatusNotifier extends ChangeNotifier {

  // clsq
  bool get isUnlockClsq => _isUnlockClsq;
  bool _isUnlockClsq = false;

  void changeClsqUnlockStatus(bool status) async {
    if (_isUnlockClsq != status) {
      _isUnlockClsq = status;
      notifyListeners();
    }
  }

  // awjq
  bool get isUnlockAwjq => _isUnlockAwjq;
  bool _isUnlockAwjq = false;

  void changeAwjqUnlockStatus(bool status) async {
    if (_isUnlockAwjq != status) {
      _isUnlockAwjq = status;
      notifyListeners();
    }
  }

  // pzhan
  bool get isUnlockPzhan => _isUnlockPzhan;
  bool _isUnlockPzhan = false;

  void changePzhanUnlockStatus(bool status) async {
    if (_isUnlockPzhan != status) {
      _isUnlockPzhan = status;
      notifyListeners();
    }
  }

  // aw91
  bool get isUnlockAw91 => _isUnlockAw91;
  bool _isUnlockAw91 = false;

  void changeAw91UnlockStatus(bool status) async {
    if (_isUnlockAw91 != status) {
      _isUnlockAw91 = status;
      notifyListeners();
    }
  }

  // 91zpc
  bool get isUnlockZpc91 => _isUnlockZpc91;
  bool _isUnlockZpc91 = false;

  void changeZpc91UnlockStatus(bool status) async {
    if (_isUnlockZpc91 != status) {
      _isUnlockZpc91 = status;
      notifyListeners();
    }
  }

}