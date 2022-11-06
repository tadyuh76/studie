import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

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
                const SizedBox(height: kMediumPadding),
                const Text(
                  "📚 Không khí thư viện",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_off_rounded, color: kDarkGrey),
                    Expanded(
                      child: Slider(
                        value: 0,
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
                const SizedBox(height: kMediumPadding),
                const Text(
                  "🌧️ Tiếng mưa",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_off_rounded, color: kDarkGrey),
                    Expanded(
                      child: Slider(
                        value: 0,
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
