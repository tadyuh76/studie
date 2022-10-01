import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/create_card/create_room_button.dart';

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
          image: AssetImage('assets/images/1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Học tập\nKhông giới hạn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kWhite,
              fontSize: 24,
            ),
          ),
          SizedBox(height: kDefaultPadding),
          CreateRoomButton(),
        ],
      ),
    );
  }
}
