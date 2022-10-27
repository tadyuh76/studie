import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomSettingsNotifier extends ChangeNotifier {
  bool _cameraEnabled = false;
  bool _micEnabled = false;
  bool _switchCamera = false;

  bool get cameraEnabled => _cameraEnabled;
  bool get micEnabled => _micEnabled;
  bool get switchCamera => _switchCamera;

  void updateCamera() {
    _cameraEnabled = !_cameraEnabled;
    notifyListeners();
  }

  void updateMic() {
    _micEnabled = !_micEnabled;
    notifyListeners();
  }

  void updateSwitchCamera() {
    _switchCamera = !_switchCamera;
    notifyListeners();
  }
}

final roomSettingsProvider =
    ChangeNotifierProvider((ref) => RoomSettingsNotifier());
