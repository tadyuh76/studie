import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: "Nhập ghi chú bài học",
              ),
              onChanged: (value) {
                final previousSelection = _noteController.selection;
                _noteController.text = value;
                _noteController.selection = previousSelection;

                int cursorIndex = previousSelection.baseOffset;
                final RegExp regExp = RegExp("\n");
                int lineIndex = regExp.allMatches(_noteController.text).length;
                debugPrint(
                    "currently on line: $lineIndex, at $cursorIndex chars");
              },
              scrollPadding: const EdgeInsets.all(20.0),
              keyboardType: TextInputType.multiline,
              maxLines: 1000,
            )
          ],
        ),
      ),
    );
  }
}
