import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/navigator_index_provider.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigatorIndexProvider);

    return SizedBox(
      height: 60,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: kWhite,
          border: Border.fromBorderSide(
            BorderSide(color: kLightGrey, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      ref.read(navigatorIndexProvider.notifier).state = 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/home.svg',
                        width: 32,
                        height: 32,
                        color: currentIndex == 0 ? kPrimaryColor : kDarkGrey,
                      ),
                      Text(
                        'Trang chủ',
                        style: TextStyle(
                          color: currentIndex == 0 ? kPrimaryColor : kDarkGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: kPrimaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(CreateRoomScreen.routeName),
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/plus.svg',
                      width: 24,
                      height: 24,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      ref.read(navigatorIndexProvider.notifier).state = 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/cards.svg',
                        width: 32,
                        height: 32,
                        color: currentIndex == 1 ? kPrimaryColor : kDarkGrey,
                      ),
                      Text(
                        'Balo',
                        style: TextStyle(
                          color: currentIndex == 1 ? kPrimaryColor : kDarkGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
