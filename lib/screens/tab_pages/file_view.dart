import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewPage extends ConsumerStatefulWidget {
  const FileViewPage({super.key});

  @override
  ConsumerState<FileViewPage> createState() => _FileViewPageState();
}

class _FileViewPageState extends ConsumerState<FileViewPage>
    with AutomaticKeepAliveClientMixin {
  String? _fileUrl;
  String? _fileType;
  bool loading = false;

  bool get isPdf => _fileType == "pdf";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final room = ref.read(roomProvider).room;
    if (room!.fileUrl.isNotEmpty && room.fileType.isNotEmpty) {
      setState(() {
        _fileUrl = room.fileUrl;
        _fileType = room.fileType;
      });
    }
  }

  Future<void> _pickFile() async {
    setState(() => loading = true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    final fileBytes = file.bytes;
    if (fileBytes == null) return;

    try {
      final roomId = ref.read(roomProvider).room!.id;
      final fileDir =
          FirebaseStorage.instance.ref('/files/$roomId/${file.name}');
      final res = await fileDir.putData(fileBytes);
      final fileUrl = await res.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .update({"fileUrl": fileUrl, "fileType": file.extension});

      _fileUrl = fileUrl;
    } catch (e) {
      debugPrint("error putting file on storage: $e");
    }

    setState(() {
      _fileType = file.extension;
      loading = false;
    });
  }

  void _resetFile() {
    setState(() {
      _fileType = null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) return const LoadingScreen();

    if (_fileUrl != null && _fileUrl!.isNotEmpty) {
      return Scaffold(
        // body: _renderFile(),
        body: _renderFile(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding),
          child: Opacity(
            opacity: 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "refresh",
                  tooltip: "Làm mới",
                  onPressed: _resetFile,
                  backgroundColor: kPrimaryColor,
                  child: const Icon(
                    Icons.close,
                    color: kWhite,
                    size: kIconSize,
                  ),
                ),
                const SizedBox(height: kMediumPadding),
                FloatingActionButton(
                  heroTag: "add",
                  tooltip: "Thêm ảnh/tệp khác",
                  onPressed: _pickFile,
                  backgroundColor: kPrimaryColor,
                  child: SvgPicture.asset(
                    "assets/icons/file_add.svg",
                    color: kWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(kMediumPadding),
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: kPrimaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                // color: kPrimaryColor,
              ),
              child: SvgPicture.asset(
                'assets/icons/file_add.svg',
                color: kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          const SizedBox(
            width: 200,
            child: Text(
              "Nhấn để thêm file ảnh/PDF cho phòng học",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kBlack,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderFile() {
    return isPdf
        ? SfPdfViewer.network(
            _fileUrl!,
          )
        : PhotoView(
            imageProvider: NetworkImage(_fileUrl!),
            backgroundDecoration: const BoxDecoration(color: kBlack),
            minScale: PhotoViewComputedScale.contained,
            maxScale: 2.0,
          );
  }

  // Widget _renderAssetFile() {
  //   return isPdf
  //       ? SfPdfViewer.memory(
  //           _filePicked!,
  //           controller: PdfViewerController(),
  //           onDocumentLoadFailed: (details) =>
  //               debugPrint("loaded fail: $details"),
  //         )
  //       : PhotoView(
  //           imageProvider: MemoryImage(_filePicked!),
  //           backgroundDecoration: const BoxDecoration(color: kBlack),
  //           minScale: PhotoViewComputedScale.contained,
  //           maxScale: 2.0,
  //         );
  // }
}
