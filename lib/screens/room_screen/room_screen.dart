import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/screens/room_screen/widgets/app_bar.dart';
import 'package:studie/screens/room_screen/widgets/pomodoro.dart';
import 'package:studie/screens/room_screen/widgets/study_session.dart';
import 'package:studie/screens/room_screen/widgets/tab_pages/camera_view.dart';
import 'package:studie/screens/room_screen/widgets/tab_pages/chats.dart';
import 'package:studie/screens/room_screen/widgets/tab_pages/file_view.dart';
import 'package:studie/screens/room_screen/widgets/tab_pages/whiteboard.dart';
import 'package:studie/services/db_methods.dart';

const Map<String, Widget> tabs = {
  "camera": CameraViewPage(),
  "image": FileViewPage(),
  "chats": ChatsPage(),
  "whiteboard": WhiteboardPage(),
};

class RoomScreen extends StatefulWidget {
  final Room room;
  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _pageController = PageController(initialPage: 0);
  int _currentTabIndex = 0;

  void onTabTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  void onPageChanged(int index) {
    _currentTabIndex = index;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    DBMethods().leaveRoom(widget.room.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: RoomAppBar(roomName: widget.room.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kMediumPadding),
            child: Row(
              children: [
                const Pomodoro(),
                const SizedBox(width: kMediumPadding),
                const GoalSession(),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Material(
                    color: kLightGrey,
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/popup_menu.svg',
                          color: kTextColor,
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          renderTabNavigator(),
          renderTabView(),
        ],
      ),
    );
  }

  Row renderTabNavigator() {
    return Row(
      children: [
        for (int i = 0; i < tabs.length; i++)
          TabItem(
            iconName: tabs.keys.elementAt(i),
            isActive: i == _currentTabIndex,
            onTap: () => onTabTap(i),
          )
      ],
    );
  }

  Expanded renderTabView() {
    return Expanded(
      child: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: [
          for (int i = 0; i < tabs.length; i++) tabs.values.elementAt(i),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String iconName;
  final bool isActive;
  final VoidCallback onTap;
  const TabItem({
    Key? key,
    required this.iconName,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: isActive ? kPrimaryColor : kLightGrey),
          child: SvgPicture.asset(
            'assets/icons/$iconName.svg',
            color: isActive ? kWhite : kDarkGrey,
          ),
        ),
      ),
    );
  }
}
