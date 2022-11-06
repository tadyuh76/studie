import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/widgets/form/form_title.dart';

class PomodoroSetting extends StatelessWidget {
  final void Function(String?) onTap;
  const PomodoroSetting({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormTitle(title: 'Pomodoro nhóm'),
        const SizedBox(height: kMediumPadding),
        DropdownButtonFormField(
          value: "pomodoro_50",
          items: [
            DropdownMenuItem(
              value: 'pomodoro_50',
              onTap: () => onTap("pomodoro_50"),
              child: const Text(
                '50 phút Tập trung - 10 phút nghỉ',
                style: TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'pomodoro_25',
              onTap: () => onTap("pomodoro_25"),
              child: const Text(
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
