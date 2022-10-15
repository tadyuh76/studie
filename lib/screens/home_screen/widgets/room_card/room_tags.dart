import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class RoomTags extends StatelessWidget {
  final List<dynamic> tags;
  const RoomTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags
            .map(
              (tag) => Container(
                margin: const EdgeInsets.only(right: kMediumPadding),
                padding: const EdgeInsets.symmetric(
                  vertical: kSmallPadding,
                  horizontal: kMediumPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: kDarkGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
