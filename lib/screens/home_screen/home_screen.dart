import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/navigator_index_provider.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/screens/alchemy_screen/alchemy_screen.dart';
import 'package:studie/screens/home_screen/widgets/custom_drawer.dart';
import 'package:studie/screens/home_screen/widgets/progress_tracker.dart';
import 'package:studie/screens/home_screen/widgets/rooms_section.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';
import 'package:studie/widgets/bottom_nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _menuController;
  bool loading = true;
  bool isMenuOpen = false;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    ref
        .read(userProvider)
        .getUser()
        .then((_) => setState(() => loading = false));
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
        y = size.height * 0.1;
      }
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
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
                    appBar: renderAppBar(context),
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

    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
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
          child: CircleAvatar(
            radius: 16,
            child: ClipOval(
              child: Image.network(
                  "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
            ),
          ),
        ),
      ],
      title: const Text(
        'Studie',
        style: TextStyle(
          color: kTextColor,
          fontWeight: FontWeight.bold,
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

    return currentIndex == 0
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: kMediumPadding),
                SearchBar(height: 50, hintText: 'Tìm phòng học'),
                SizedBox(height: kDefaultPadding),
                ProgressTracker(),
                SizedBox(height: kDefaultPadding),
                RoomsSection(),
              ],
            ),
          )
        : const AlchemyScreen();
  }
}
