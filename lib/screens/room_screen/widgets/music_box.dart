import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class MusicBox extends StatefulWidget {
  final VoidCallback hideBox;
  final void Function(double, String) startMusic;
  final void Function(String) stopMusic;
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
  double lofi = 0;
  double library = 0;
  double rain = 0;

  bool get lofiMute => lofi == 0;
  bool get libraryMute => library == 0;
  bool get rainMute => rain == 0;

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
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 8, color: kShadow)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                    GestureDetector(
                      onTap: widget.hideBox,
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: kMediumPadding),
                const Text(
                  "🌠 Lofi",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(
                      libraryMute ? Icons.volume_off_rounded : Icons.volume_up,
                      color: kDarkGrey,
                    ),
                    Expanded(
                      child: Slider(
                        value: lofi,
                        onChanged: (value) {
                          if (value > 0) {
                            widget.startMusic(value, "lofi");
                          } else {
                            widget.stopMusic("lofi");
                          }
                          setState(() {
                            lofi = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kMediumPadding),
                const Text(
                  "📚 Thư viện",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(
                      libraryMute ? Icons.volume_off_rounded : Icons.volume_up,
                      color: kDarkGrey,
                    ),
                    Expanded(
                      child: Slider(
                        value: library,
                        onChanged: (value) {
                          if (value > 0) {
                            widget.startMusic(value, "library");
                          } else {
                            widget.stopMusic("library");
                          }
                          setState(() {
                            library = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kMediumPadding),
                const Text(
                  "🌧️ Mưa",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(
                      rainMute ? Icons.volume_off_rounded : Icons.volume_up,
                      color: kDarkGrey,
                    ),
                    Expanded(
                      child: Slider(
                        value: rain,
                        onChanged: (value) {
                          if (value > 0) {
                            widget.startMusic(value, "rain");
                          } else {
                            widget.stopMusic("rain");
                          }
                          setState(() {
                            rain = value;
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
