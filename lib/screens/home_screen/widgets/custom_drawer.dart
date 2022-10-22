import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/user.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/widgets/avatar.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  void onLogOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider).user;

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
                  renderUserInfo(user),
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

  Widget renderUserInfo(UserModel user) {
    return Row(
      children: [
        Avatar(photoURL: user.photoURL, radius: 24),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                  fontSize: 14,
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                user.email,
                maxLines: 1,
                style: const TextStyle(
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
