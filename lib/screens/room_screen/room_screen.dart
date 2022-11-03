import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/providers/pomodoro_provider.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/document_screen/document_screen.dart';
import 'package:studie/screens/room_screen/tab_pages/camera_view.dart';
import 'package:studie/screens/room_screen/tab_pages/chats_view.dart';
import 'package:studie/screens/room_screen/tab_pages/file_view.dart';
import 'package:studie/screens/room_screen/widgets/app_bar.dart';
import 'package:studie/screens/room_screen/widgets/pomodoro_widget.dart';
import 'package:studie/screens/room_screen/widgets/study_session.dart';
import 'package:studie/utils/show_custom_dialogs.dart';
import 'package:studie/widgets/dialogs/custom_dialog.dart';
import 'package:studie/widgets/dialogs/leave_dialog.dart';

final Map<String, Widget> tabs = {
  "camera": const CameraViewPage(),
  "image": const FileViewPage(),
  "chats": ChatsPage(),
  "notes": const DocumentScreen(),
};

final globalKey = GlobalKey();

class RoomScreen extends ConsumerStatefulWidget {
  static const routeName = "/room";
  final Room room;
  const RoomScreen({super.key, required this.room});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen>
    with WidgetsBindingObserver {
  final _pageController = PageController(initialPage: 0);
  late AudioPlayer _audioPlayer;
  int _currentTabIndex = 0;
  bool showMusicBox = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _setUpMusic();

    final pomodoro = ref.read(pomodoroProvider);
    pomodoro.initTimer("pomodoro_50");
    pomodoro.startTimer(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state, [mounted = true]) {
    // if (state == AppLifecycleState.resumed && mounted) {
    //   showSnackBar(
    //     context,
    //     "Đã rời khỏi phòng học do thoát ứng dụng đột ngột!",
    //   );
    // }
    // if (state == AppLifecycleState.paused) {
    //   ref.read(roomProvider).exitRoom(widget.room.id);
    //   ref.read(pomodoroProvider).reset();
    //   Navigator.of(context).pop();
    // }
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
        ref.read(roomProvider).exitRoom(widget.room.id);
        ref.read(pomodoroProvider).reset();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }),
    );

    return false;
  }

  void _onDisplayMusic() {
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
            key: globalKey,
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
                            onTap: _onDisplayMusic,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/music.svg',
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
          ),
          Visibility(
            visible: showMusicBox,
            child: MusicBox(
              hideBox: _onDisplayMusic,
              startMusic: _onMusicStart,
              stopMusic: _onMusicStop,
            ),
          ),
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
          ),
        ),
      ),
    );
  }
}

class MusicBox extends StatefulWidget {
  final VoidCallback hideBox;
  final VoidCallback startMusic;
  final VoidCallback stopMusic;
  const MusicBox({
    super.key,
    required this.hideBox,
    required this.startMusic,
    required this.stopMusic,
  });

  @override
  State<MusicBox> createState() => _MusicBoxState();
}

class _MusicBoxState extends State<MusicBox> {
  double volume = 0;
  bool get mute => volume == 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kToolbarHeight + 100,
          right: kDefaultPadding,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 280,
            height: 200,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 8, color: kShadow)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/music.svg",
                      color: kBlack,
                      height: kIconSize,
                      width: kIconSize,
                    ),
                    const SizedBox(width: kMediumPadding),
                    const Text(
                      "Nhạc nền",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: widget.hideBox,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const Text(
                  "🌠 Lofi",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(
                      mute ? Icons.volume_off_rounded : Icons.volume_up,
                      color: kDarkGrey,
                    ),
                    Expanded(
                      child: Slider(
                        value: volume,
                        onChanged: (value) {
                          if (value > 0) {
                            widget.startMusic();
                          } else {
                            widget.stopMusic();
                          }
                          setState(() {
                            volume = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
