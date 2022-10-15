import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        image: const DecorationImage(
          image: AssetImage('assets/images/card_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bạn đã hoàn thành được 60% mục tiêu!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kWhite,
            ),
          ),
          const Text(
            'Hoàn thành để nhận nguyên tố mới',
            style: TextStyle(
              fontSize: 14,
              color: kWhite,
              height: 1.8,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(kMediumPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return LinearPercentIndicator(
                            padding: const EdgeInsets.all(0),
                            width: constraints.maxWidth,
                            lineHeight: 16,
                            progressColor: kPrimaryColor,
                            backgroundColor: kLightGrey,
                            percent: 0.6,
                            barRadius: const Radius.circular(20),
                            animation: true,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    const Text(
                      "30",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                    const Text(
                      "/50p",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kDarkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 64,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  'assets/icons/hidden_element.svg',
                  height: 32,
                  width: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
