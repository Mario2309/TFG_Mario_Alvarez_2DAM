// core/utils/password_visibility_controller.dart
import 'package:flutter/material.dart';

class PasswordVisibilityController extends ChangeNotifier {
  bool _isObscured = true;

  bool get isObscured => _isObscured;

  void toggleVisibility() {
    _isObscured = !_isObscured;
    notifyListeners();
  }
}
