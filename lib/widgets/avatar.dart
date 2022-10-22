import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/colors.dart';

class Avatar extends StatelessWidget {
  final String photoURL;
  final double radius;
  const Avatar({super.key, required this.photoURL, required this.radius});

  @override
  Widget build(BuildContext context) {
    return photoURL.isEmpty
        ? CircleAvatar(
            backgroundColor: kWhite,
            radius: radius,
            child: ClipRRect(child: SvgPicture.asset("assets/icons/user.svg")),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(photoURL),
            radius: radius,
          );
  }
}
