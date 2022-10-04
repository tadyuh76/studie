import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/screens/home_screen/widgets/create_card/progress_tracker.dart';

class CreateCard extends StatelessWidget {
  const CreateCard({super.key});

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
      child: const ProgressTracker(),
    );
  }
}
