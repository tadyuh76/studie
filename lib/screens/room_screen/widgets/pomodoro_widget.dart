import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/screens/room_screen/widgets/utility_tab.dart';

class PomodoroWidget extends ConsumerWidget {
  const PomodoroWidget({super.key});

  void _showPomodoroBox(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => const _PomodoroBox(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UtilityTab(
      icon: 'clock',
      title: 'Pomodoro',
      value: ref.watch(pomodoroProvider).studiedTime.toString(),
      onTap: () => _showPomodoroBox(context),
    );
  }
}

class _PomodoroBox extends StatelessWidget {
  const _PomodoroBox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kToolbarHeight + 80, left: kDefaultPadding),
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
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Consumer(builder: (context, ref, _) {
                  final pomodoro = ref.watch(pomodoroProvider);
                  final studiedTime = pomodoro.studiedTime;
                  final timePerSession = pomodoro.timePerSession;

                  return CircularPercentIndicator(
                    radius: 100,
                    percent: studiedTime / timePerSession,
                    progressColor: kPrimaryColor,
                    backgroundColor: kLightGrey,
                    lineWidth: 12,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: false,
                    center: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$studiedTime",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: "/$timePerSession",
                            style: const TextStyle(
                              color: kDarkGrey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
