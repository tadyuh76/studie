import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/document_screen/tabs/folder_tab.dart';
import 'package:studie/screens/document_screen/tabs/notes_tab.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final _pageController = PageController();
  int _tabIndex = 0;

  void switchTab(int tabIndex) {
    _tabIndex = tabIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        titleSpacing: 0,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            renderTabTitle(title: "Ghi chú", index: 0),
            const SizedBox(width: kDefaultPadding * 2),
            renderTabTitle(title: "Thư mục", index: 1),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Column(
            children: [
              const SearchBar(
                height: 50,
                hintText: "Tìm kiếm ghi chú/flashcard",
                color: kLightGrey,
              ),
              const SizedBox(height: kMediumPadding),
              _tabIndex == 0 ? const NotesTab() : const FolderTab()
            ],
          )
        ],
      ),
    );
  }

  Widget renderTabTitle({required String title, required int index}) {
    final active = _tabIndex == index;
    final icon = index == 0 ? "notes" : "folder";

    return GestureDetector(
      onTap: () => switchTab(index),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? kPrimaryColor : kDarkGrey,
              fontSize: 20,
            ),
          ),
          // SvgPicture.asset(
          //   "assets/icons/$icon.svg",
          //   color: active ? kPrimaryColor : kDarkGrey,
          //   width: 32,
          //   height: 32,
          // ),
          Opacity(
            opacity: active ? 1 : 0,
            child: const Icon(
              Icons.expand_more_rounded,
              color: kPrimaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
