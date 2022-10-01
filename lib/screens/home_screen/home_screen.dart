import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/widgets/create_card/create_card.dart';
import 'package:studie/screens/home_screen/widgets/custom_drawer.dart';
import 'package:studie/screens/home_screen/widgets/room_card/rooms_section.dart';
import 'package:studie/screens/home_screen/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _menuController;
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
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          ),
        )
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomDrawer(),
        AnimatedContainer(
          curve: Curves.easeInCubic,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius:
                isMenuOpen ? BorderRadius.circular(kDefaultPadding) : null,
            boxShadow: isMenuOpen
                ? [const BoxShadow(blurRadius: 32, color: kShadow)]
                : null,
          ),
          transform: Matrix4.translationValues(x, y, 0)
            ..scale(isMenuOpen ? 0.8 : 1.00),
          duration: const Duration(milliseconds: 300),
          child: Scaffold(
            appBar: renderAppBar(context),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: kMediumPadding),
                  SearchBar(),
                  SizedBox(height: kDefaultPadding),
                  CreateCard(),
                  SizedBox(height: kDefaultPadding),
                  // ProgressTracker(),
                  RoomsSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
