import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class SearchBar extends StatelessWidget {
  final double height;
  final String hintText;
  const SearchBar({super.key, required this.height, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: kLightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hintText,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              color: kDarkGrey,
              fontSize: 14,
            ),
          ),
          SvgPicture.asset('assets/icons/search.svg')
        ],
      ),
    );
  }
}
