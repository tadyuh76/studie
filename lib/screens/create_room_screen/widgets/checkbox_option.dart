import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class CheckBoxOption extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool enabled;
  final void Function(bool?) onTap;
  const CheckBoxOption({
    Key? key,
    required this.text,
    required this.icon,
    required this.enabled,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: enabled,
          activeColor: kPrimaryColor,
          side: const BorderSide(width: 2, color: kPrimaryColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          onChanged: onTap,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: kMediumPadding),
        Icon(icon, color: kPrimaryColor)
      ],
    );
  }
}
