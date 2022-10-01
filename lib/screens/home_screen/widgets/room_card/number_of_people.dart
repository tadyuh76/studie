import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class NumberOfPeopleInRoom extends StatelessWidget {
  final int numPeople;
  final int maxPeople;
  const NumberOfPeopleInRoom({
    super.key,
    required this.numPeople,
    required this.maxPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -10,
      right: kDefaultPadding,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/people.svg', color: kPrimaryColor),
            const SizedBox(width: kMediumPadding),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$numPeople',
                    style: const TextStyle(
                      color: kTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/$maxPeople',
                    style: const TextStyle(
                      color: kDarkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
