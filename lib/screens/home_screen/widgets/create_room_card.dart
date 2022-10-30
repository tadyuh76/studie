import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class CreateRoomCard extends StatelessWidget {
  const CreateRoomCard({super.key});

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
        children: const [
          Text(
            'Học cùng nhau không giới hạn!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kWhite,
            ),
          ),
          Text(
            'Hoàn thành để nhận nguyên tố mới',
            style: TextStyle(
              fontSize: 14,
              color: kWhite,
              height: 1.8,
            ),
          ),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
