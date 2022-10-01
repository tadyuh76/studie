import 'package:flutter/material.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';

class StudySession extends StatelessWidget {
  const StudySession({super.key});

  @override
  Widget build(BuildContext context) {
    return const UtilityTab(
      icon: 'goal',
      title: 'Phiên học',
      value: '0/3',
    );
  }
}
