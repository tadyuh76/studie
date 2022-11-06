import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/goal.dart';

// TODO: implement id later
class GoalNotifier extends ChangeNotifier {
  List<Goal> goals = [];

  void addGoal(String text) {
    final newGoal = Goal(text: text, completed: false);
    goals = [newGoal, ...goals];
    notifyListeners();
  }

  void deleteGoal(String text) {
    goals.removeWhere((goal) => goal.text == text);
    notifyListeners();
  }

  void completeGoal(String text) {
    for (final goal in goals) {
      if (goal.text == text) goal.doneTask();
    }
    notifyListeners();
  }

  void reset() {
    goals = [];
  }
}

final goalsProvider = ChangeNotifierProvider((ref) => GoalNotifier());
