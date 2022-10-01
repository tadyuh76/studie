import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kMediumPadding,
      ),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: kLightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 3 * kDefaultPadding,
            barRadius: const Radius.circular(10),
            lineHeight: 20,
            backgroundColor: kPrimaryLight,
            progressColor: kPrimaryColor,
            percent: 0.7,
          ),
          const SizedBox(height: kDefaultPadding),
          Column(
            children: const [
              Text(
                'Bạn đã hoàn thành 70% mục tiêu hôm nay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kTextColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
