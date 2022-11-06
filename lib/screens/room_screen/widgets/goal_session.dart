import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/providers/goals_provider.dart';
import 'package:studie/screens/room_screen/widgets/goals_box.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';

class GoalSession extends ConsumerWidget {
  const GoalSession({super.key});

  void hideBox(BuildContext context) {
    Navigator.of(context).pop();
  }

  void showGoalsBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => GoalsBox(hideBox: () => hideBox(context)),
      barrierColor: Colors.transparent,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider).goals;
    final allGoals = goals.length;
    final completedGoals =
        goals.fold(0, (val, goal) => goal.completed ? ++val : val);
    return UtilityTab(
      icon: 'goal',
      title: 'Mục tiêu',
      value: "$completedGoals/$allGoals",
      onTap: () => showGoalsBox(context),
    );
  }
}
