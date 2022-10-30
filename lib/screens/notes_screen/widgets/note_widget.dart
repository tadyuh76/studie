import "package:flutter/material.dart";
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/note_edit_screen/note_edit_screen.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  const NoteWidget({super.key, required this.note});

  void onNoteTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Material(
        color: bannerColors[note.color],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onNoteTab(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
              vertical: kDefaultPadding,
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
                  note.folderName,
                  style: const TextStyle(fontSize: 14, color: kWhite),
                ),
                const SizedBox(height: kDefaultPadding),
                Text(
                  note.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kWhite, fontSize: 14),
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
