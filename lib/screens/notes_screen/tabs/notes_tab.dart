import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/notes_screen/widgets/note_widget.dart';

final notes = [
  Note(
    title: "Dao động điều hòa",
    text:
        "I. Khái niệm: Dao động điều hòa là dao động tuần hoàn mà phương trình trạng thái được biểu diễn dưới dạng các hàm điều hoà (sin hoặc cosin)",
    lastEdit: DateTime.now().toString(),
    id: "",
    color: "blue",
    numberOfFlashcards: 12,
  ),
  Note(
    id: "",
    title: "Mã di truyền",
    text:
        "Mã di truyền là trật tự các nucleotit trên gen quy định trật tự các axit amin trên protein",
    lastEdit: DateTime.now().toString(),
    color: "black",
    numberOfFlashcards: 7,
  ),
  Note(
    id: "",
    title: "Nhiễm sắc thể",
    text: "Nhiễm sắc thể là vật chất di truyền ở cấp độ tế bào",
    lastEdit: DateTime.now().toString(),
    color: "lavender",
    numberOfFlashcards: 13,
  ),
  Note(
    id: "",
    title: "Đường glucozo",
    text: "Đường glucozo là một monosaccarit có công thức phân tử là C6H12O6",
    lastEdit: DateTime.now().toString(),
    color: "orange",
    numberOfFlashcards: 11,
  ),
  Note(
    id: "",
    title: "Media Vocabulary & Phrases",
    text:
        "to broadcast propaganda: to send out a programme on television or radio that may be false or eexagerrated in order to gain support for a political leader, a party etc",
    lastEdit: DateTime.now().toString(),
    color: "blue",
    numberOfFlashcards: 20,
  ),
];

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    "Gần dây",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: kSmallPadding),
                  NoteWidget(note: notes[0]),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    "Tất cả",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                      fontSize: 20,
                    ),
                  ),
                ],
              );
            }

            return NoteWidget(note: notes[index]);
          },
        ),
      ),
    );
  }
}
