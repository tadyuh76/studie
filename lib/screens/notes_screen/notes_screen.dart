import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';
import 'package:studie/screens/notes_screen/tabs/folder_tab.dart';
import 'package:studie/screens/notes_screen/tabs/notes_tab.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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
        backgroundColor: kWhite,
        titleSpacing: 0,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            renderTabTitle(title: "Ghi chú", index: 0),
            const SizedBox(width: kMediumPadding),
            renderTabTitle(title: "Thư mục", index: 1),
          ],
        ),
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

    return GestureDetector(
      onTap: () => switchTab(index),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? kPrimaryColor : kDarkGrey,
              fontSize: 20,
            ),
          ),
          if (active)
            const Icon(
              Icons.expand_more_rounded,
              color: kPrimaryColor,
              size: 20,
            ),
        ],
      ),
    );
  }
}
