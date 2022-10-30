import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/screens/room_screen/room_screen.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/widgets/dialogs/breaktime_dialog.dart';
import 'package:studie/widgets/dialogs/return_from_breaktime.dart';

const minute = 60;

class PomodoroNotifier extends ChangeNotifier {
  Timer? _studyTimer, _breaktimeTimer;
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

  bool get isStudying => _isStudying;
  bool get isBreaktime => _isBreaktime;

  void initTimer(String pomodoroType, [int totalSessions = 3]) {
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
        _timePerSession = (0.1 * minute).toInt();
        _breaktimeDuration = (0.1 * minute).toInt();
        _longbreakDuration = 2 * minute;
    }
    _remainTime = _timePerSession;
    _remainBreaktime = _breaktimeDuration;
    _totalSessions = totalSessions;
    _remainSessions = totalSessions;
  }

  void setupStudyTimer() {
    _remainTime = _timePerSession;
    // notifyListeners();
  }

  void startTimer(BuildContext context) {
    if (_isStudying || _isBreaktime) return;

    _isStudying = true;

    _studyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainTime--;

      if (_remainTime == 0) {
        timer.cancel();
        _isStudying = false;
        _remainSessions--;

        setupBreaktimeTimer();
        showCustomDialog(
          context: globalKey.currentState!.context,
          dialog: const BreaktimeDialog(),
          canDismiss: false,
        );
      }
      notifyListeners();
    });
  }

  void setupBreaktimeTimer() {
    final numSessionsCompleted = _totalSessions - _remainSessions;
    final isLongBreak = numSessionsCompleted % 3 == 0;
    _remainBreaktime = (numSessionsCompleted > 0 && isLongBreak)
        ? _longbreakDuration
        : _breaktimeDuration;
    notifyListeners();
  }

  void startBreaktime() {
    if (_isBreaktime) return;

    _isBreaktime = true;

    _breaktimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainBreaktime--;
      if (_remainBreaktime == 0) {
        timer.cancel();
        _isBreaktime = false;

        showCustomDialog(
          context: globalKey.currentState!.context,
          dialog: const ReturnFromBreaktimeDialog(),
          canDismiss: false,
        );
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    _isStudying = false;
    _studyTimer!.cancel();
    notifyListeners();
  }

  void continueTimer() {
    startTimer(globalKey.currentState!.context);
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
    _studyTimer?.cancel();
    _breaktimeTimer?.cancel();
    notifyListeners();
  }
}

final pomodoroProvider = ChangeNotifierProvider((ref) => PomodoroNotifier());
