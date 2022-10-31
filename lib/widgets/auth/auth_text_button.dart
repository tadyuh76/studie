import 'package:flutter/material.dart';
import 'package:studie/constants/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool primary;
  final bool rounded;
  final bool loading;
  final bool disabled;
  final bool large;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.primary = false,
    this.loading = false,
    this.disabled = false,
    this.rounded = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: primary ? kPrimaryColor : kLightGrey,
        borderRadius: BorderRadius.circular(rounded ? 40 : 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            // width: double.infinity,
            alignment: Alignment.center,
            padding:
                EdgeInsets.symmetric(vertical: large ? 15 : 10, horizontal: 20),
            child: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: kWhite,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: primary ? kWhite : kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
