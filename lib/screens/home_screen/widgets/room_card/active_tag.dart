import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class ActiveTag extends StatelessWidget {
  const ActiveTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSmallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 12,
            width: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kSuccess,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: kWhite.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: kSmallPadding),
          const Text(
            'Live',
            style: TextStyle(color: kSuccess, fontSize: 12),
          )
        ],
      ),
    );
  }
}
