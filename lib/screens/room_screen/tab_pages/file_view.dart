import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:photo_view/photo_view.dart';

class FileViewPage extends ConsumerStatefulWidget {
  const FileViewPage({super.key});

  @override
  ConsumerState<FileViewPage> createState() => _FileViewPageState();
}

class _FileViewPageState extends ConsumerState<FileViewPage>
    with AutomaticKeepAliveClientMixin {
  String? _fileUrl;
  String? _fileType;
  Uint8List? _filePicked;
  bool loading = false;

  bool get isPdf => _fileType == "pdf";
  bool get picked => _filePicked != null;

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickFile() async {
    setState(() => loading = true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    final fileBytes = file.bytes;
    if (fileBytes == null) return;

    try {
      final roomId = ref.read(roomProvider).room!.id;
      final fileDir = FirebaseStorage.instance.ref('$roomId/${file.name}');
      final res = await fileDir.putData(fileBytes);
      final fileUrl = await res.ref.getDownloadURL();
      print("put file successfully");
      _fileUrl = fileUrl;
    } catch (e) {
      print("error putting file on storage: $e");
    }

    setState(() {
      _filePicked = fileBytes;
      _fileType = file.extension;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) return const LoadingScreen();

    if (picked) {
      return Scaffold(
        body: isPdf
            ? SfPdfViewer.memory(
                _filePicked!,
                controller: PdfViewerController(),
                onDocumentLoadFailed: (details) =>
                    print("loaded fail: $details"),
              )
            : PhotoView(
                imageProvider: MemoryImage(_filePicked!),
                backgroundDecoration: const BoxDecoration(color: kBlack),
                minScale: PhotoViewComputedScale.contained,
                maxScale: 2.0,
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding),
          child: Opacity(
            opacity: 0.8,
            child: FloatingActionButton(
              onPressed: _pickFile,
              backgroundColor: kPrimaryColor,
              child:
                  SvgPicture.asset("assets/icons/file_add.svg", color: kWhite),
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
}
