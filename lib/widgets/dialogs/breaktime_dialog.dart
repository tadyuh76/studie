import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/utils/format_time.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

class BreaktimeDialog extends ConsumerWidget {
  const BreaktimeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final remainBreaktime = formatTime(pomodoro.remainBreaktime);

    if (pomodoro.isStudying) return const SizedBox.shrink();

    return CustomDialog(
      title: "Nghỉ ngơi xíu nhé!",
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Lottie.network(
              "https://assets4.lottiefiles.com/packages/lf20_xkbhgbld.json",
              animate: true,
              repeat: true,
              width: constraints.maxWidth * 0.8,
            );
          }),
          const SizedBox(height: kMediumPadding),
          Text(
            remainBreaktime,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          const Text(
            "Đứng đậy đi lại một xíu, uống ngụm nước rồi quay lại học tiếp nhé!",
            style: TextStyle(fontSize: 16, color: kBlack),
          ),
          const SizedBox(height: kDefaultPadding),
          CustomTextButton(
            text: "Giải lao",
            onTap: () {
              Navigator.pop(context);
              pomodoro.startBreaktime();
            },
            primary: true,
          ),
        ],
      ),
    );
  }
}
