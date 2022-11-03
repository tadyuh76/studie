import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/flashcard.dart';
import 'package:studie/models/note.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/flashcard_screen/flashcard_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/utils/show_snack_bar.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

const flashcardIdentifier = ">> ";
const headerIdentifier = "#";

class NoteEditScreen extends StatefulWidget {
  static const routeName = "/note_edit";

  const NoteEditScreen({super.key, required this.note});
  final Note note;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _dbMethods = DBMethods();
  final _titleController = TextEditingController();
  final _documentController = _DocCustomController();
  int flashcardsCreated = 0;
  bool saved = true;
  bool saving = false;

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
    final previousSelection = _titleController.selection;
    _titleController.text = newTitle;
    _titleController.selection = previousSelection;

    if (saved) setState(() => saved = false);
  }

  void _onDocumentChanged(String text) {
    final previousSelection = _documentController.selection;
    _documentController.text = text;
    _documentController.selection = previousSelection;

    if (saved) setState(() => saved = false);
  }

  void _onSaved() async {
    setState(() => saving = true);

    _dismissKeyboard();
    final doc = _documentController.text;
    widget.note.copyWith(newTitle: _titleController.text, newText: doc);

    await _dbMethods.updateNote(widget.note.id, widget.note);
    await _dbMethods.deleteAllFlashcards(widget.note.id);

    flashcardsCreated = 0;
    String curTitle = "";
    doc.split("\n").forEach((line) {
      //TODO: change later
      if (line.contains(headerIdentifier)) {
        curTitle = line.substring(1).trim();
      }
      if (line.contains(flashcardIdentifier)) {
        final sides = line.split(flashcardIdentifier);
        _createFlashcard(curTitle, sides[0], sides[1]);
        flashcardsCreated++;
      }
    });

    saved = true;
    saving = false;
    setState(() {});
  }

  void _createFlashcard(String curTitle, String front, String back) async {
    final Flashcard flashcard = Flashcard(
      front: front,
      back: back,
      curTitle: curTitle,
      noteName: widget.note.title,
      folderName: widget.note.folderName,
      revisedTimes: 0,
    );

    final res = await DBMethods().putFlashcardToNote(widget.note.id, flashcard);
    if (mounted && res != "success") {
      showSnackBar(context, "Lỗi tải flashcard: $res");
    }
  }

  Widget _renderFlashcardsBadge() {
    return Positioned(
      top: 10,
      right: 0,
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          "$flashcardsCreated",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kWhite,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> _onExit() async {
    _dismissKeyboard();
    if (saved) return true;

    showCustomDialog(
      context: context,
      dialog: CustomDialog(
        title: "Thoát chỉnh sửa",
        child: Column(
          children: [
            const Text(
              "Bạn có thay đổi chưa được lưu. Lưu chúng ?",
              style: TextStyle(color: kBlack, fontSize: 16),
            ),
            const SizedBox(height: kDefaultPadding),
            CustomTextButton(
              text: "Lưu và thoát",
              primary: true,
              onTap: () {
                _onSaved();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );

    return false;
  }

  Future<void> _shareNote(BuildContext context, WidgetRef ref) async {
    final roomId = ref.read(roomProvider).room?.id;
    if (roomId == null) {
      return showSnackBar(
        context,
        "Bạn cần ở trong một phòng học mới có thể chia sẻ",
      );
    }

    final res = await _dbMethods.shareDocumentWithRoom(widget.note, roomId);
  }

  _renderDefaultLeading() {
    return [
      IconButton(
        splashRadius: kIconSize,
        onPressed: () {},
        icon: SvgPicture.asset(
          "assets/icons/color.svg",
          height: kIconSize,
          width: kIconSize,
        ),
      ),
      Consumer(builder: (context, ref, _) {
        return IconButton(
          splashRadius: kIconSize,
          onPressed: () => _shareNote(context, ref),
          icon: SvgPicture.asset(
            "assets/icons/share.svg",
            height: kIconSize,
            width: kIconSize,
          ),
        );
      }),
      Padding(
        padding:
            const EdgeInsets.only(right: kDefaultPadding, left: kSmallPadding),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AllFlashcardsScreen(noteId: widget.note.id),
            )),
            child: SizedBox(
              width: kIconSize + 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/cards.svg",
                    width: kIconSize,
                    height: kIconSize,
                  ),
                  if (flashcardsCreated != 0) _renderFlashcardsBadge()
                ],
              ),
            ),
          ),
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
    ];
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final lastEditTime = DateTime.parse(widget.note.lastEdit);
    final lastEditDay =
        "${lastEditTime.day}/${lastEditTime.month}/${lastEditTime.year}";
    final lastEditHour =
        "${lastEditTime.hour.toString().padLeft(2, "0")}:${lastEditTime.minute.toString().padLeft(2, "0")}";

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: kWhite,
          elevation: 0,
          foregroundColor: kBlack,
          actions: [
            if (MediaQuery.of(context).viewInsets.bottom > 0.0)
              ..._renderActiveLeading()
            else
              ..._renderDefaultLeading(),
            if (saving)
              IconButton(
                onPressed: () {},
                icon: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (!saved && !saving)
              IconButton(
                splashRadius: kIconSize,
                onPressed: _onSaved,
                icon: const Icon(
                  Icons.check,
                  color: kPrimaryColor,
                  size: kIconSize,
                ),
              ),
          ],
        ),
        body: WillPopScope(
          onWillPop: _onExit,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    maxLines: null,
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
                    style: const TextStyle(fontSize: 14, color: kDarkGrey),
                  ),
                  const SizedBox(height: kMediumPadding),
                  TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    maxLength: TextField.noMaxLength,
                    controller: _documentController,
                    maxLines: null,
                    onChanged: _onDocumentChanged,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: kDarkGrey),
                      hintText: "Nhập nội dung...",
                    ),
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
    return line.contains(">> ") || line.contains("<> ") || line.contains("<< ");
  }

  String _getFlashcardType(String line) {
    final toDirection = line.contains(">> ") ? ">> " : "";
    final fromDirection = line.contains("<< ") ? "<< " : "";
    final twoDirection = line.contains("<> ") ? "<> " : "";

    if (toDirection.isNotEmpty) return toDirection;
    if (fromDirection.isNotEmpty) return fromDirection;
    return twoDirection;
  }

  TextSpan _renderFlashcard(String line, TextStyle style) {
    final cardType = _getFlashcardType(line);
    final cardSides = line.split(cardType);
    final symbol = cardType == ">> "
        ? " → "
        : cardType == "<< "
            ? " ← "
            : " ↔ ";
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
