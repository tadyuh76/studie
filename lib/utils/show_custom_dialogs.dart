import 'package:flutter/material.dart';
import 'package:studie/constants/colors.dart';

void showCustomDialog({required BuildContext context, required Widget dialog}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: kBlack.withOpacity(0.5),
    builder: (_) => dialog,
  );
}
