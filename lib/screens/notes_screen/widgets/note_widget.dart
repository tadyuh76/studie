import "package:flutter/material.dart";
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  const NoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kMediumPadding,
          vertical: kDefaultPadding + kMediumPadding,
        ),
        decoration: BoxDecoration(
          color: bannerColors[note.color],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                color: kWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "${note.numberOfFlashcards} thẻ",
              style: const TextStyle(fontSize: 12, color: kLightGrey),
            ),
            const SizedBox(height: kDefaultPadding),
            Text(
              note.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kWhite,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
