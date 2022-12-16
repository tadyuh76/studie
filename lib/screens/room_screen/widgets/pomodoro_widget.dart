import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';
import 'package:studie/utils/format_time.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';

class PomodoroWidget extends ConsumerWidget {
  const PomodoroWidget({super.key});

  void _showPomodoroBox(BuildContext context, bool isBreaktime) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => _PomodoroBox(isBreaktime),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final isBreaktime = pomodoro.isBreaktime;
    final remainTime =
        isBreaktime ? pomodoro.remainBreaktime : pomodoro.remainTime;

    return UtilityTab(
      icon: 'clock',
      title: isBreaktime ? 'Giải lao' : "Pomodoro",
      value: formatTime(remainTime),
      onTap: () => _showPomodoroBox(context, isBreaktime),
    );
  }
}

class _PomodoroBox extends StatelessWidget {
  final bool isBreaktime;
  const _PomodoroBox(this.isBreaktime);

  @override
  Widget build(BuildContext context) {
    if (isBreaktime) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(
        top: kToolbarHeight + 80,
        left: kDefaultPadding,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 240,
          height: 300,
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [BoxShadow(blurRadius: 4, color: kShadow)],
          ),
          child: Consumer(builder: (context, ref, _) {
            final pomodoro = ref.watch(pomodoroProvider);

            return Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularPercentIndicator(
                    radius: 100,
                    percent: pomodoro.studiedTime / pomodoro.timePerSession,
                    progressColor: kPrimaryColor,
                    backgroundColor: kLightGrey,
                    lineWidth: 12,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: false,
                    center: Text(
                      formatTime(pomodoro.remainTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextButton(
                  text: pomodoro.isStudying ? "Tạm dừng" : "Tiếp tục",
                  primary: true,
                  onTap: () {
                    pomodoro.isStudying
                        ? pomodoro.stopTimer()
                        : pomodoro.startTimer(context);
                  },
                ),
              ],
            );
            // return Container();
          }),
        ),
      ),
    );
  }
}
