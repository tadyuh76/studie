import 'package:flutter/material.dart';
import 'package:studie/constants/colors.dart';

void showCustomDialog({
  required BuildContext context,
  required Widget dialog,
  bool canDismiss = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: canDismiss,
    barrierColor: kBlack.withOpacity(0.5),
    builder: (_) => dialog,
  );
}
