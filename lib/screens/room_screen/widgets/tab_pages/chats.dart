import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/message_box.dart';

final messages = [
  Message(
    id: '0',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '1',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '2',
    senderId: 'hehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'hehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'hehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
  Message(
    id: '3',
    senderId: 'ehe',
    senderName: 'Huy',
    senderPhotoURL: 'senderPhotoURL',
    text: 'Hello World',
    createdAt: DateTime.now().toString(),
  ),
];

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
    final roomId = ref.read(roomProvider).room!.id;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: StreamBuilder(
              stream: DBMethods().getMessages(roomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs
                      .map((doc) =>
                          Message.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    addRepaintBoundaries: false,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MessageBox(message: messages[index]);
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Text('error getting messages: ${snapshot.error}');
                }

                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
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
