import 'package:flutter/material.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/widgets/form/form_title.dart';

class CreateRoomInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;

  const CreateRoomInput({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormTitle(title: title),
        TextFormField(
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
      ],
    );
  }
}
