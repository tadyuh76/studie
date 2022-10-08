import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class NumberOfPeopleInRoom extends StatelessWidget {
  final int curParticipants;
  final int maxParticipants;
  const NumberOfPeopleInRoom({
    super.key,
    required this.curParticipants,
    required this.maxParticipants,
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
                    text: '$curParticipants',
                    style: const TextStyle(
                      color: kTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/$maxParticipants',
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
