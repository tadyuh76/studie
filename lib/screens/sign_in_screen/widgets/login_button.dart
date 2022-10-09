import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class LoginButton extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;
  const LoginButton({
    Key? key,
    required this.iconName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kMediumPadding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: kPrimaryLight),
        ),
        child: SvgPicture.asset(
          'assets/icons/$iconName.svg',
          color: kPrimaryColor,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
