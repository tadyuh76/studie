import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/folder.dart';

class FolderWidget extends ConsumerWidget {
  final Folder folder;
  const FolderWidget({super.key, required this.folder});

  void onNoteTab(BuildContext context, WidgetRef ref) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => NoteEditScreen(folder: folder),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Material(
        color: bannerColors[folder.color],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onNoteTab(context, ref),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
              vertical: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/icons/folder.svg",
                  color: kWhite,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: kMediumPadding),
                Text(
                  folder.name,
                  style: const TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${folder.numOfDocs} tài liệu",
                  style: const TextStyle(fontSize: 14, color: kWhite),
                ),
                const SizedBox(height: kDefaultPadding),
                // Text(
                //   folder.text,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(color: kWhite, fontSize: 14),
                // ),
                // const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
