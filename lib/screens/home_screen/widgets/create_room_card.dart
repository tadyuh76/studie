import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';
import 'package:studie/screens/solo_study_screen/solo_study_screen.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';

class CreateRoomCard extends StatelessWidget {
  const CreateRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        image: const DecorationImage(
          image: AssetImage('assets/images/card_bg.png'),
          fit: BoxFit.cover,
        ),
        color: bannerColors["blue"],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Học cùng nhau',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: kWhite,
            ),
          ),
          const SizedBox(height: kMediumPadding),
          const Text(
            'Kết nối những ý tưởng chung\nmọi lúc, mọi nơi!',
            style: TextStyle(
              fontSize: 16,
              color: kLightGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          CustomTextButton(
            text: "Tạo phòng học",
            onTap: () {
              showCustomDialog(
                context: context,
                dialog: CustomDialog(
                  title: "Tạo phòng học",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CustomRoomButton(
                        iconName: "group_study",
                        title: "Phòng học nhóm",
                        subtitle:
                            "Học với những học sinh tràn đầy năng lượng từ mọi nơi, cùng nhau sáng tạo!",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushNamed(CreateRoomScreen.routeName);
                        },
                      ),
                      const Divider(
                          color: kDarkGrey, height: kDefaultPadding * 2),
                      Opacity(
                        opacity: 0.5,
                        child: IgnorePointer(
                          ignoring: true,
                          child: _CustomRoomButton(
                            iconName: "solo_study",
                            title: "Phòng học cá nhân",
                            subtitle:
                                "Tạo không gian học thoải mái với mục tiêu của bạn và nhiều công cụ tiện lợi!",
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(SoloStudyScreen.routeName);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _CustomRoomButton extends StatelessWidget {
  final String iconName;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _CustomRoomButton({
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: kLightGrey,
            ),
            child: SvgPicture.asset(
              "assets/icons/$iconName.svg",
              width: 80,
              height: 80,
            ),
          ),
        ),
        const SizedBox(width: kMediumPadding),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: kBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    subtitle,
                    // maxLines: 3,
                    style: const TextStyle(
                      color: kBlack,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
