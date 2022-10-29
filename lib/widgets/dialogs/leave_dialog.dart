import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

class LeaveDialog extends ConsumerWidget {
  final VoidCallback onExit;
  const LeaveDialog(this.onExit, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      title: "Thoát phòng học",
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return SvgPicture.asset(
              "assets/svgs/leave.svg",
              width: constraints.maxWidth,
            );
          }),
          const SizedBox(height: kDefaultPadding),
          const Text(
            "Bạn có thực sự muốn rời phòng học?",
            style: TextStyle(fontSize: 16, color: kBlack),
          ),
          const SizedBox(height: kDefaultPadding),
          CustomTextButton(text: "Thoát", primary: true, onTap: onExit),
        ],
      ),
    );
  }
}
