import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

const urls = [
  "https://i.pinimg.com/originals/73/5d/73/735d73725f77188e554756b5e11a2bf1.gif",
  "https://64.media.tumblr.com/c5618390d59033d341b682965dbd6e86/84903493406da5f8-97/s640x960/f5d53d4a76ab7d5f5a19ad26f55a1e2c9aabc15e.gif"
];

class ChillPage extends StatefulWidget {
  const ChillPage({super.key});

  @override
  State<ChillPage> createState() => _ChillPageState();
}

class _ChillPageState extends State<ChillPage>
    with AutomaticKeepAliveClientMixin {
  String imageUrl = "";

  @override
  bool get wantKeepAlive => true;

  void setImage(String url) {
    imageUrl = url;
    setState(() {});
  }

  void hideBackgroundSelector() {
    Navigator.of(context).pop();
  }

  void showBackgroundSelector() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (context) => _BackgroundSelector(
        setImage: setImage,
        hideBox: hideBackgroundSelector,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding),
        child: FloatingActionButton(
          heroTag: "background",
          backgroundColor: kPrimaryColor,
          onPressed: showBackgroundSelector,
          child: SvgPicture.asset(
            'assets/icons/image.svg',
            color: kWhite,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: imageUrl.isEmpty
            ? const SizedBox.expand(
                child: DecoratedBox(decoration: BoxDecoration(color: kBlack)),
              )
            : PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(color: kBlack),
                maxScale: 2.0,
                minScale: PhotoViewComputedScale.contained,
              ),
      ),
    );
  }
}

class _BackgroundSelector extends StatelessWidget {
  final VoidCallback hideBox;
  final void Function(String) setImage;
  const _BackgroundSelector({required this.hideBox, required this.setImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kToolbarHeight + 80,
        right: kDefaultPadding,
      ),
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: kWhite,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/image.svg",
                      color: kBlack,
                      height: kIconSize,
                      width: kIconSize,
                    ),
                    const SizedBox(width: kMediumPadding),
                    const Text(
                      "Ảnh nền",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: hideBox,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: kSmallPadding,
                    mainAxisSpacing: kSmallPadding,
                  ),
                  itemCount: urls.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => setImage(urls[index]),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: kBlack,
                        image: DecorationImage(
                          image: NetworkImage(urls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
