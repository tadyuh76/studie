import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/navigator_index_provider.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/screens/home_screen/home_screen.dart';
import 'package:studie/screens/home_screen/widgets/custom_drawer.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/screens/document_screen/document_screen.dart';
import 'package:studie/widgets/avatar.dart';
import 'package:studie/widgets/bottom_nav.dart';

class RootScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';
  const RootScreen({super.key});

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends ConsumerState<RootScreen>
    with TickerProviderStateMixin {
  bool loading = true, isMenuOpen = false;

  double x = 0, y = 0;
  late AnimationController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    getData();
  }

  Future<void> getData() async {
    await ref.read(userProvider).updateUser();
    loading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _menuController.dispose();
  }

  void onMenuTap(Size size) {
    setState(() {
      if (isMenuOpen) {
        _menuController.reverse();
        x = 0;
        y = 0;
      } else {
        _menuController.forward();
        x = size.width * 0.7;
        y = size.height * 0.15;
      }
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingScreen()
        : Stack(
            children: [
              const CustomDrawer(),
              AnimatedContainer(
                curve: Curves.easeInCubic,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: isMenuOpen
                      ? BorderRadius.circular(kDefaultPadding)
                      : null,
                  boxShadow: isMenuOpen
                      ? [const BoxShadow(blurRadius: 32, color: kShadow)]
                      : null,
                ),
                transform: Matrix4.translationValues(x, y, 0)
                  ..scale(isMenuOpen ? 0.8 : 1.00),
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    if (isMenuOpen) onMenuTap(MediaQuery.of(context).size);
                  },
                  onTap: () {
                    if (isMenuOpen) onMenuTap(MediaQuery.of(context).size);
                  },
                  child: Scaffold(
                    appBar: ref.watch(navigatorIndexProvider) == 0
                        ? renderAppBar(context)
                        : null,
                    backgroundColor: kWhite,
                    bottomNavigationBar: const BottomNav(),
                    body: const _MainBody(),
                  ),
                ),
              ),
            ],
          );
  }

  AppBar renderAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider).user;

    return AppBar(
      centerTitle: true,
      backgroundColor: kWhite,
      elevation: 0,
      leading: Center(
        child: IconButton(
          splashRadius: 25,
          onPressed: () => onMenuTap(size),
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: _menuController,
            color: kTextColor,
            size: kIconSize,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding),
          child: Avatar(photoURL: user.photoURL, radius: 14),
        ),
      ],
      title: const Text(
        "Study247",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: kBlack,
          fontSize: 24,
        ),
      ),
    );
  }
}

class _MainBody extends ConsumerWidget {
  const _MainBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigatorIndexProvider);

    return currentIndex == 0 ? const HomeScreen() : const DocumentScreen();
  }
}
