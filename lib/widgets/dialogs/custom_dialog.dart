import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Alignment alignment;
  final Widget child;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: kWhite,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    bottom: kMediumPadding,
                    right: kDefaultPadding,
                    left: kDefaultPadding,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  color: kDarkGrey,
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: child,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
