import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const minute = 60;

class PomodoroNotifier extends ChangeNotifier {
  int _timePerSession = 0,
      _breaktimeDuration = 0,
      _longbreakDuration = 0,
      _totalSessions = 0,
      _remainTime = 0,
      _remainBreaktime = 0,
      _remainSessions = 0;

  bool _isStudying = false, _isBreaktime = false;

  String get formattedTime {
    int minutes = (_remainTime / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    return minutesStr;
  }

  int get timePerSession => _timePerSession;
  int get breaktimeDuration => _breaktimeDuration;
  int get longBreakDuration => _longbreakDuration;
  int get totalSessions => _totalSessions;

  int get studiedTime => _timePerSession - _remainTime;
  int get remainTime => _remainTime;
  int get remainBreaktime => _remainBreaktime;
  int get remainSessions => _remainSessions;

  bool get isStrudying => _isStudying;
  bool get isBreaktime => _isBreaktime;

  initTimer(String pomodoroType, [int totalSessions = 3]) {
    switch (pomodoroType) {
      case "pomodoro_25":
        _timePerSession = 25 * minute;
        _breaktimeDuration = 5 * minute;
        _longbreakDuration = 15 * minute;
        break;
      case "pomodoro_50":
        _timePerSession = 50 * minute;
        _breaktimeDuration = 10 * minute;
        _longbreakDuration = 30 * minute;
        break;
      default:
        _timePerSession = 50 * minute;
        _breaktimeDuration = 10 * minute;
        _longbreakDuration = 30 * minute;
    }
    _totalSessions = totalSessions;
    _remainSessions = totalSessions;
  }

  startTimer() {
    if (_isStudying) return;

    _isStudying = true;
    _isBreaktime = false;

    _remainTime = _timePerSession;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainTime--;
      if (_remainTime == 0) {
        timer.cancel();
        _isStudying = false;
      }
      notifyListeners();
    });
  }

  startBreaktime() {
    if (_isBreaktime) return;

    _isStudying = false;
    _isBreaktime = true;

    final numSessionsCompleted = _totalSessions - _remainSessions;
    final isLongBreak = numSessionsCompleted % 3 == 0;
    _remainBreaktime = isLongBreak ? _longbreakDuration : _breaktimeDuration;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainBreaktime--;
      if (_remainBreaktime == 0) {
        timer.cancel();
        _remainSessions--;
        _isBreaktime = true;
      }
      notifyListeners();
    });
  }

  void reset() {
    _timePerSession = 0;
    _breaktimeDuration = 0;
    _longbreakDuration = 0;
    _totalSessions = 0;
    _remainTime = 0;
    _remainBreaktime = 0;
    _remainSessions = 0;
    _isStudying = false;
    _isBreaktime = false;
    notifyListeners();
  }
}

final pomodoroProvider = ChangeNotifierProvider((ref) => PomodoroNotifier());
