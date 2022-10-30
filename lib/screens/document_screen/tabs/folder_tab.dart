import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/folder.dart';
import 'package:studie/screens/document_screen/widgets/folder_widget.dart';
import 'package:studie/widgets/hide_scrollbar.dart';

final folders = [
  Folder(name: "Vật lý", color: "blue", numOfDocs: 12, docIds: []),
  Folder(name: "Hóa học", color: "red", numOfDocs: 5, docIds: []),
  Folder(name: "Sinh học", color: "green", numOfDocs: 3, docIds: []),
  Folder(name: "Tiếng Anh", color: "lavender", numOfDocs: 8, docIds: []),
];

class FolderTab extends StatelessWidget {
  const FolderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HideScrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gần đây",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: kSmallPadding),
                  FolderWidget(folder: folders[0]),
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

            return FolderWidget(folder: folders[index]);
          },
        ),
      ),
    );
  }
}
