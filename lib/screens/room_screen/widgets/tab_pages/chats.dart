import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
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

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            addRepaintBoundaries: false,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            itemCount: messages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return MessageBox(message: messages[index]);
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: const BoxDecoration(
                  color: kLightGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tin nhắn...',
                  style: TextStyle(
                    color: kDarkGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: kMediumPadding),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset(
                'assets/icons/send.svg',
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
