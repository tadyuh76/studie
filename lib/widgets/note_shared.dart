import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/document_screen/widgets/note_widget.dart';
import 'package:studie/services/db_methods.dart';

class NoteSharedWidget extends StatelessWidget {
  final Message messageWithNote;
  const NoteSharedWidget({super.key, required this.messageWithNote});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
      child: Container(
        width: 240,
        padding: const EdgeInsets.only(top: kSmallPadding),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(kMediumPadding),
              child: Flexible(
                child: Text(
                  "${messageWithNote.senderName} đang chia sẻ tài liệu này với phòng học",
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: DBMethods().getSharedNote(
                  messageWithNote.senderId, messageWithNote.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return NoteWidget(
                    note: Note.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
