import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/flashcard.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

const defaultTextStyle = TextStyle(
  color: kBlack,
  fontSize: 16,
  fontFamily: "Quicksand",
);

class AllFlashcardsScreen extends StatefulWidget {
  final String noteId;
  const AllFlashcardsScreen({super.key, required this.noteId});

  @override
  State<AllFlashcardsScreen> createState() => _AllFlashcardsScreenState();
}

class _AllFlashcardsScreenState extends State<AllFlashcardsScreen> {
  final _pageController = PageController();

  void _nextPage() async {
    final curPage = _pageController.page;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    final newPage = _pageController.page;
    if (curPage == newPage && mounted) {
      // TODO: implement saving new flashcards
      showCustomDialog(
        context: context,
        dialog: CustomDialog(
          title: "Hoàn thành ôn tập!",
          child: Column(
            children: [
              Lottie.asset(
                "assets/lottie/loading_complete.json",
                repeat: false,
                animate: true,
                height: 200,
                width: 200,
              ),
              const SizedBox(height: kDefaultPadding),
              CustomTextButton(
                text: "Trở lại",
                primary: true,
                onTap: Navigator.of(context).pop,
              ),
            ],
          ),
        ),
      );
    }
  }

  void onEasy() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  void onHard() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  void onNeedRevise() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBMethods().getFlashcardsFromNote(widget.noteId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final flashcards = snapshot.data!.docs
            .map(
              (doc) => Flashcard.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
        flashcards.shuffle();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kWhite,
            foregroundColor: kBlack,
            centerTitle: true,
            titleSpacing: 0,
            actions: [
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: kMediumPadding),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.more_horiz),
              ),
              const SizedBox(width: kMediumPadding)
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BackgroundText(text: flashcards.length.toString()),
                Flexible(
                  child: Text(
                    " ${flashcards[0].noteName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: flashcards.length,
            itemBuilder: (context, index) => _FlashcardPage(
              curCard: flashcards[index],
              nextPage: () => _nextPage(),
              onEasy: onEasy,
              onHard: onHard,
              onNeedRevise: onNeedRevise,
            ),
          ),
        );
      },
    );
  }
}

class _FlashcardPage extends StatefulWidget {
  final Flashcard curCard;
  final VoidCallback nextPage;
  final VoidCallback onEasy;
  final VoidCallback onHard;
  final VoidCallback onNeedRevise;
  const _FlashcardPage({
    required this.curCard,
    required this.nextPage,
    required this.onEasy,
    required this.onHard,
    required this.onNeedRevise,
  });

  @override
  State<_FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<_FlashcardPage> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.curCard.folderName != "all")
            Text(widget.curCard.folderName, style: defaultTextStyle),
          const SizedBox(height: kDefaultPadding),
          _BackgroundText(text: widget.curCard.noteName),
          const SizedBox(height: kMediumPadding),
          if (widget.curCard.curTitle != "")
            Text(
              "\u2022  ${widget.curCard.curTitle}",
              style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: kSmallPadding),
          if (!showAnswer)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: kSmallPadding,
              children: [
                Text(
                  "    \u2022  ${widget.curCard.front}",
                  style: defaultTextStyle,
                ),
                Text(
                  " \u2794 ",
                  style: defaultTextStyle.copyWith(
                    color: kPrimaryColor,
                  ),
                ),
                const _BackgroundText(text: "?")
              ],
            ),
          if (showAnswer)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "    \u2022  ${widget.curCard.front}",
                    style: defaultTextStyle,
                  ),
                  TextSpan(
                    text: " \u2794 ",
                    style: defaultTextStyle.copyWith(color: kPrimaryColor),
                  ),
                  TextSpan(
                    text: widget.curCard.back,
                    style: defaultTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          if (!showAnswer)
            CustomTextButton(
              text: "Hiện đáp án",
              large: true,
              onTap: () => setState(() => showAnswer = true),
              primary: true,
            ),
          if (showAnswer)
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      large: true,
                      text: "Dễ",
                      onTap: widget.onEasy,
                      color: bannerColors["green"],
                      primary: true,
                    ),
                  ),
                  const SizedBox(width: kSmallPadding),
                  Expanded(
                    child: CustomTextButton(
                      large: true,
                      text: "Khó",
                      onTap: widget.onHard,
                      color: bannerColors["red"],
                      primary: true,
                    ),
                  ),
                  const SizedBox(width: kSmallPadding),
                  CustomTextButton(
                    large: true,
                    text: "Cần xem lại",
                    onTap: widget.onNeedRevise,
                    color: bannerColors["blue"],
                    primary: true,
                  ),
                ],
              ),
            ),
          const SizedBox(height: kDefaultPadding)
        ],
      ),
    );
  }
}

class _BackgroundText extends StatelessWidget {
  final String text;
  const _BackgroundText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: kGrey,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
          horizontal: kMediumPadding,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: kBlack,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class BackgroundText extends StatelessWidget {
  const BackgroundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
