import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/goal.dart';
import 'package:studie/providers/goals_provider.dart';

class GoalsBox extends StatelessWidget {
  final VoidCallback hideBox;
  GoalsBox({super.key, required this.hideBox});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 80),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 280,
            // height: 300,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 4, color: kShadow)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/goal.svg",
                      color: kBlack,
                      height: kIconSize,
                      width: kIconSize,
                    ),
                    const SizedBox(width: kMediumPadding),
                    const Text(
                      "Mục tiêu phiên học này",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: hideBox,
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: kMediumPadding),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(kMediumPadding),
                          hintText: "Nhập mục tiêu",
                          hintStyle: TextStyle(color: kDarkGrey, fontSize: 14),
                          hintMaxLines: 1,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: kDarkGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: kSmallPadding),
                    Consumer(
                      builder: (context, ref, _) => GestureDetector(
                        onTap: () {
                          ref.read(goalsProvider).addGoal(_controller.text);
                          _controller.clear();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.add, color: kWhite),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kMediumPadding),
                Consumer(builder: (context, ref, _) {
                  final goals = ref.watch(goalsProvider).goals;
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: ListView.builder(
                      itemCount: goals.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          GoalWidget(goal: goals[index]),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalWidget extends ConsumerWidget {
  final Goal goal;
  const GoalWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kSmallPadding)
            .copyWith(right: kMediumPadding),
        decoration: const BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: goal.completed,
                onChanged: (_) {
                  ref.read(goalsProvider).completeGoal(goal.text);
                }),
            Expanded(
              child: Text(
                goal.text,
                style: TextStyle(
                  color: kBlack,
                  fontSize: 16,
                  decoration:
                      goal.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: kSmallPadding),
            GestureDetector(
              onTap: () {
                ref.read(goalsProvider).deleteGoal(goal.text);
              },
              child: const Icon(Icons.close, color: kDarkGrey),
            )
          ],
        ),
      ),
    );
  }
}
