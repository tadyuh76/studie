import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool toggleVisible;
  final IconData iconData;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.inputType,
    this.toggleVisible = false,
    required this.iconData,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.toggleVisible && !_passwordVisible,
      autocorrect: false,
      enableSuggestions: !widget.toggleVisible,
      decoration: InputDecoration(
        focusColor: kPrimaryColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kMediumPadding,
          ),
          child: Icon(widget.iconData),
        ),
        iconColor: kPrimaryColor,
        suffixIcon: widget.toggleVisible
            ? Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                child: IconButton(
                  splashRadius: 2,
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kDarkGrey,
                  ),
                ),
              )
            : null,
        fillColor: kLightGrey,
        filled: true,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: widget.inputType,
    );
  }
}
