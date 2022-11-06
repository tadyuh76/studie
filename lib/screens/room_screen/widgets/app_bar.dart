import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class RoomAppBar extends StatelessWidget {
  final String roomName;
  const RoomAppBar({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: kTextColor,
      backgroundColor: kWhite,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              roomName,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: kDefaultPadding),
          // Container(
          //   height: 30,
          //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          //   decoration: BoxDecoration(
          //     color: kPrimaryColor,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         SvgPicture.asset(
          //           'assets/icons/add_people.svg',
          //           color: kWhite,
          //         ),
          //         const SizedBox(width: kSmallPadding),
          //         const Text(
          //           'Mời',
          //           style: TextStyle(
          //             color: kWhite,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
