import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';

class NoteEditScreen extends StatefulWidget {
  static const routeName = "/note_edit";

  const NoteEditScreen({super.key, required this.note});
  final Note note;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _documentController = _DocCustomController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _documentController.text = widget.note.text;
  }

  @override
  void dispose() {
    super.dispose();
    _documentController.dispose();
    _titleController.dispose();
  }

  void _onTitleChanged(String newTitle) {
    widget.note.copyWith(newTitle: newTitle);
  }

  void _onDocumentChanged(String text) {
    final previousSelection = _documentController.selection;
    _documentController.text = text;
    _documentController.selection = previousSelection;

    widget.note.copyWith(newText: text);
  }

  void _onEditCompleted() {
    // TODO: update the new note to database
  }

  _renderDefaultLeading() {
    return [
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: SvgPicture.asset(
          "assets/icons/share.svg",
          height: kIconSize,
          width: kIconSize,
        ),
      ),
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: SvgPicture.asset(
          "assets/icons/popup_menu.svg",
          width: kIconSize,
          height: kIconSize,
        ),
      ),
    ];
  }

  List<Widget> _renderActiveLeading() {
    return [
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: const Icon(Icons.undo, color: kDarkGrey, size: kIconSize),
      ),
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: const Icon(Icons.redo, color: kDarkGrey, size: kIconSize),
      ),
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: const Icon(Icons.check, color: kPrimaryColor, size: kIconSize),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final lastEditTime = DateTime.parse(widget.note.lastEdit);
    final lastEditDay =
        "${lastEditTime.day}/${lastEditTime.month}/${lastEditTime.year}";
    final lastEditHour =
        "${lastEditTime.hour.toString().padLeft(2, "0")}:${lastEditTime.minute.toString().padLeft(2, "0")}";

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: kWhite,
        elevation: 0,
        foregroundColor: kBlack,
        actions: [
          if (MediaQuery.of(context).viewInsets.bottom > 0.0)
            ..._renderActiveLeading()
          else
            ..._renderDefaultLeading()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 1,
                controller: _titleController,
                onChanged: _onTitleChanged,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  hintText: "Nhập tiêu đề...",
                  hintStyle: TextStyle(color: kGrey),
                  border: InputBorder.none,
                ),
              ),
              // const SizedBox(height: kDefaultPadding),
              Text(
                "$lastEditHour - $lastEditDay",
                style: const TextStyle(fontSize: 14, color: kGrey),
              ),
              TextField(
                controller: _documentController,
                maxLines: null,
                onChanged: _onDocumentChanged,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(
                  height: 1.5,
                  color: kBlack,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DocCustomController extends TextEditingController {
  bool _isHeadline(String line) {
    return line.contains("#");
  }

  TextSpan _renderHeadline(String line, TextStyle style) {
    return TextSpan(
      text: "$line\n",
      style: style.copyWith(fontWeight: FontWeight.bold),
    );
  }

  bool _isFlashcard(String line) {
    return line.contains(">> ");
  }

  TextSpan _renderFlashcard(String line, TextStyle style) {
    final cardSides = line.split(">> ");
    final frontSideText = cardSides[0];
    final backSideText = cardSides[1];

    return TextSpan(
      children: [
        TextSpan(text: frontSideText, style: style),
        TextSpan(text: " \u2794 ", style: style.copyWith(color: kPrimaryColor)),
        TextSpan(text: "$backSideText\n", style: style),
      ],
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final texts = value.text.split("\n").map((line) {
      if (_isHeadline(line)) return _renderHeadline(line, style!);
      if (_isFlashcard(line)) return _renderFlashcard(line, style!);

      return TextSpan(text: "$line\n", style: style);
    });

    return TextSpan(style: style, children: texts.toList());
  }
}
