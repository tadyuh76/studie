import 'package:flutter/material.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';

class GoalSession extends StatelessWidget {
  const GoalSession({super.key});

  @override
  Widget build(BuildContext context) {
    return const UtilityTab(
      icon: 'goal',
      title: 'Mục tiêu',
      value: '0/3',
    );
  }
}
