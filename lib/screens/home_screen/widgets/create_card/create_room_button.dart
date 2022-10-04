import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';

class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(CreateRoomScreen.routeName),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kSmallPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/add.svg', color: kPrimaryColor),
              const SizedBox(width: kMediumPadding),
              const Text(
                'Tạo phòng học mới',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
