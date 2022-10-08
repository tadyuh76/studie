import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final bool optional;
  const FormTitle({
    super.key,
    required this.title,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kDarkGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: kMediumPadding),
        if (optional)
          const Text(
            '(Tùy chọn)',
            style: TextStyle(color: kDarkGrey),
          )
      ],
    );
  }
}
