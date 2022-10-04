import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studie/constants/colors.dart';

class CreateRoomInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final String type;

  const CreateRoomInput({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.type = 'text',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kDarkGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        type == 'text' ? renderTextInput() : renderNumberInput(),
      ],
    );
  }

  renderNumberInput() {
    return SizedBox(
      width: 100,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: kLightGrey,
            fontSize: 12,
            height: 1,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 4,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  renderTextInput() {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: kLightGrey,
          fontSize: 12,
          height: 1,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 4,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
