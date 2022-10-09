import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void onLogOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.7),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  renderUserInfo(),
                  const SizedBox(height: kDefaultPadding),
                  TabItem(
                    text: 'Trang chủ',
                    iconName: 'home',
                    focus: true,
                    onTap: () {},
                  ),
                  TabItem(
                    text: 'Cài đặt',
                    iconName: 'settings',
                    onTap: () {},
                  ),
                  TabItem(
                    text: 'Về ứng dụng',
                    iconName: 'info',
                    onTap: () {},
                  ),
                  TabItem(
                    text: 'Đăng xuất',
                    iconName: 'log_out',
                    onTap: () => onLogOut(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderUserInfo() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.jpg'),
          radius: 24,
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Đạt Huy',
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                  fontSize: 14,
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                'tadyuh76@gmail.com',
                maxLines: 1,
                style: TextStyle(
                  color: kDarkGrey,
                  fontSize: 14,
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  final bool focus;
  final String text;
  final String iconName;
  final VoidCallback onTap;
  const TabItem({
    super.key,
    this.focus = false,
    required this.text,
    required this.iconName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      child: Material(
        color: focus ? kPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/$iconName.svg',
                  color: focus ? kWhite : kDarkGrey,
                ),
                const SizedBox(width: kDefaultPadding),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: focus ? kWhite : kDarkGrey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
