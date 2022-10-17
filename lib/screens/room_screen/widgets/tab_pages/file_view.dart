import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewPage extends StatelessWidget {
  const FileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.asset('assets/test.pdf');
  }
}
