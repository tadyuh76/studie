import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/widgets/form/form_title.dart';

class PomodoroSetting extends StatelessWidget {
  final String pomodoroType;
  const PomodoroSetting({super.key, required this.pomodoroType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormTitle(title: 'Pomodoro nhóm'),
        const SizedBox(height: kMediumPadding),
        DropdownButtonFormField(
          value: pomodoroType,
          items: const [
            DropdownMenuItem(
              value: 'pomodoro_50',
              child: Text(
                '50 phút Tập trung - 10 phút nghỉ',
                style: TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'pomodoro_25',
              child: Text(
                '25 phút Tập trung - 5 phút nghỉ',
                style: TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }
}
