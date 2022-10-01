import 'package:flutter/material.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';

class Pomodoro extends StatelessWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context) {
    return const UtilityTab(
      icon: 'clock',
      title: 'Pomodoro',
      value: '00:39:24',
    );
  }
}
