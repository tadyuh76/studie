import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/screens/room_screen/room_screen.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

class ReturnFromBreaktimeDialog extends ConsumerWidget {
  const ReturnFromBreaktimeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      title: "Học tiếp nào!",
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return LottieBuilder.network(
              "https://assets8.lottiefiles.com/packages/lf20_y2j3e9ze.json",
              animate: true,
              repeat: true,
              width: constraints.maxWidth * 0.8,
            );
          }),
          CustomTextButton(
            text: "Học tiếp",
            primary: true,
            onTap: () {
              Navigator.pop(context);
              ref.read(pomodoroProvider)
                ..setupStudyTimer()
                ..startTimer(globalKey.currentState!.context);
            },
          ),
        ],
      ),
    );
  }
}
