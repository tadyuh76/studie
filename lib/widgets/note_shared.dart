import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/document_screen/widgets/note_widget.dart';
import 'package:studie/services/auth_methods.dart';
import 'package:studie/services/db_methods.dart';

class NoteSharedWidget extends StatelessWidget {
  final Message messageWithNote;
  final _authMethods = AuthMethods();

  NoteSharedWidget({super.key, required this.messageWithNote});

  bool get isSender => messageWithNote.senderId == _authMethods.user!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
      child: Container(
        width: 240,
        decoration: const BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMediumPadding)
                  .copyWith(bottom: kMediumPadding),
              child: _SharedNoteData(messageWithNote: messageWithNote),
            ),
            Container(
              decoration: BoxDecoration(
                color: isSender ? kPrimaryColor : kLightGrey,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(kMediumPadding),
              child: Flexible(
                child: Text(
                  "${messageWithNote.senderName} đang chia sẻ tài liệu này với phòng học",
                  style: TextStyle(
                    color: isSender ? kWhite : kBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: kWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedNoteData extends StatelessWidget {
  const _SharedNoteData({
    Key? key,
    required this.messageWithNote,
  }) : super(key: key);

  final Message messageWithNote;

  @override
  Widget build(BuildContext context) {
    //TODO: optimize cache later
    return FutureBuilder(
      future: DBMethods().getSharedNote(
        messageWithNote.senderId,
        messageWithNote.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final note = Note.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );

          return NoteWidget(note: note);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
