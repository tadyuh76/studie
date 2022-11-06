import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/goals_provider.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/screens/document_screen/document_screen.dart';
import 'package:studie/screens/room_screen/widgets/goal_session.dart';
import 'package:studie/screens/room_screen/widgets/music_box.dart';
import 'package:studie/screens/room_screen/widgets/pomodoro_widget.dart';
import 'package:studie/screens/tab_pages/chill_page.dart';
import 'package:studie/screens/tab_pages/file_view.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/widgets/dialogs/leave_dialog.dart';

final Map<String, Widget> tabs = {
  // "chill": const ChillPage(),
  "file": const FileViewPage(),
  "notes": const DocumentScreen(),
};

class SoloStudyScreen extends ConsumerStatefulWidget {
  static const routeName = "/solo";
  const SoloStudyScreen({super.key});

  @override
  ConsumerState<SoloStudyScreen> createState() => _SoloStudyScreenState();
}

class _SoloStudyScreenState extends ConsumerState<SoloStudyScreen> {
  int _currentTabIndex = 0;
  bool showMusicBox = false;
  late AudioPlayer _audioPlayer;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setUpMusic();

    final pomodoro = ref.read(pomodoroProvider);
    pomodoro.initTimer("pomodoro_50");
    pomodoro.startTimer(context);
  }

  void onTabTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    _currentTabIndex = index;
    setState(() {});
  }

  Future<bool> _onQuitRoom() async {
    showCustomDialog(
      context: context,
      dialog: LeaveDialog(() {
        ref.read(pomodoroProvider).reset();
        ref.read(goalsProvider).reset();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }),
    );

    return false;
  }

  void _onDisplayMusicBox() {
    showMusicBox = !showMusicBox;
    setState(() {});
  }

  Future<void> _setUpMusic() async {
    await _audioPlayer.setUrl(
      "https://firebasestorage.googleapis.com/v0/b/studie-a9c68.appspot.com/o/lofis%2FMorning-Routine-Lofi-Study-Music.mp3?alt=media&token=c8eb9b4b-b7aa-46d2-98a8-d2c3cc50d323",
    );
  }

  void _onMusicStart() {
    if (_audioPlayer.playing) return;
    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.play();
  }

  void _onMusicStop() async {
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onQuitRoom,
      child: Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: _renderAppBar(),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: kMediumPadding),
                  child: Row(
                    children: [
                      const PomodoroWidget(),
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
                            onTap: _onDisplayMusicBox,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/music.svg',
                                color: kBlack,
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
          ),
          Visibility(
            visible: showMusicBox,
            child: MusicBox(
              hideBox: _onDisplayMusicBox,
              startMusic: _onMusicStart,
              stopMusic: _onMusicStop,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _renderAppBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
        backgroundColor: kWhite,
        foregroundColor: kBlack,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          "Phòng học cá nhân",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: kBlack,
          ),
        ),
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
        physics: const NeverScrollableScrollPhysics(),
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
            width: kIconSize,
            height: kIconSize,
          ),
        ),
      ),
    );
  }
}
