import 'package:flutter/material.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';

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
        color: bannerColors["blue"],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Học cùng nhau',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: kWhite,
            ),
          ),
          const SizedBox(height: kMediumPadding),
          const Text(
            'Kết nối những ý tưởng chung\nmọi lúc, mọi nơi!',
            style: TextStyle(
              fontSize: 16,
              color: kLightGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          CustomTextButton(
            text: "Tạo phòng học",
            onTap: () =>
                Navigator.of(context).pushNamed(CreateRoomScreen.routeName),
          )
        ],
      ),
    );
  }
}
