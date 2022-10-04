import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/create_card/create_room_button.dart';
import 'package:studie/widgets/custom_text_button.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 60,
          lineWidth: 8,
          backgroundColor: kWhite,
          progressColor: kPrimaryColor,
          circularStrokeCap: CircularStrokeCap.round,
          percent: 0.7,
          center: const Text(
            '20 phút',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kWhite,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Học thêm 10 phút để mở khóa nguyên tố mới !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kWhite,
                ),
              ),
              SizedBox(height: kDefaultPadding),
              CreateRoomButton()
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   mainAxisSize: MainAxisSize.max,
    //   children: [
    //     CircularPercentIndicator(
    //       radius: 32,
    //       lineWidth: 8,
    //       backgroundColor: kPrimaryLight,
    //       progressColor: kPrimaryColor,
    //       percent: 0.7,
    //     ),
    //     const SizedBox(width: kDefaultPadding),
    //     Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Text(
    //           'Học thêm 10 phút để mở khóa nguyên tố mới!',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 12,
    //             color: kTextColor,
    //           ),
    //         ),
    //         CustomTextButton(
    //           text: 'Tạo phòng học',
    //           onTap: () {},
    //           primary: false,
    //         )
    //       ],
    //     )
    //   ],
    // );
  }
}
