import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/widgets/form/form_title.dart';

class NumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  const NumberInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = '5';
  }

  void increaseValue() {
    String curVal = widget.controller.text;
    if (int.parse(curVal) >= 50) return;
    widget.controller.text = (int.parse(curVal) + 1).toString();
  }

  void decreaseValue() {
    String curVal = widget.controller.text;
    if (int.parse(curVal) <= 0) return;
    widget.controller.text = (int.parse(curVal) - 1).toString();
  }

  void validate(String value) {
    if (value.isEmpty) return;
    if (int.parse(value) >= 50) {
      widget.controller.text = '50';
    }
  }

  void onEditingComplete() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormTitle(title: widget.title),
          const SizedBox(height: kMediumPadding),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Material(
                  color: kLightGrey,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: InkWell(
                    onTap: decreaseValue,
                    child: const Icon(Icons.remove),
                  ),
                ),
              ),
              const SizedBox(width: kMediumPadding),
              SizedBox(
                width: 80,
                height: 40,
                child: TextFormField(
                  onEditingComplete: onEditingComplete,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: widget.controller,
                  onChanged: validate,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
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
              ),
              const SizedBox(width: kMediumPadding),
              SizedBox(
                height: 40,
                width: 40,
                child: Material(
                  color: kLightGrey,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: InkWell(
                    onTap: increaseValue,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
