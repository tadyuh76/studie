import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/hide_scrollbar.dart';
import 'package:studie/widgets/message_box.dart';

class ChatsPage extends ConsumerWidget {
  ChatsPage({super.key});

  final _messageController = TextEditingController();

  void sendMessage(String roomId) {
    if (_messageController.text.trim().isEmpty) return;

    DBMethods().sendMessage(_messageController.text.trim(), roomId);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomId = ref.read(roomProvider).room.id;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return StreamBuilder(
            stream: DBMethods().getMessages(roomId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "Trò chuyện, trao đổi về bài học tại đây !",
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) =>
                        Message.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                return HideScrollbar(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: ListView.builder(
                      addRepaintBoundaries: false,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox(height: kDefaultPadding);
                        }
                        return MessageBox(message: messages[index - 1]);
                      },
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('error getting messages: ${snapshot.error}');
              }

              return const LoadingScreen();
            });
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kMediumPadding,
          horizontal: kDefaultPadding,
        ).copyWith(bottom: kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => sendMessage(roomId),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    hintText: 'Tin nhắn...',
                    hintStyle: const TextStyle(fontSize: 14, color: kDarkGrey),
                    filled: true,
                    fillColor: kLightGrey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: kMediumPadding),
            Consumer(builder: (context, ref, _) {
              return Material(
                color: kPrimaryColor,
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: () => sendMessage(roomId),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/send.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
