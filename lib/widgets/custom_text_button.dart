import 'package:flutter/material.dart';
import 'package:studie/constants/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool primary;
  final bool loading;
  final bool disabled;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.primary,
    this.loading = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Material(
        color: primary ? kPrimaryColor : kLightGrey,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15),
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
                      color: primary ? kWhite : kTextColor,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
