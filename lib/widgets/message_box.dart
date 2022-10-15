import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';

class MessageBox extends StatelessWidget {
  final Message message;
  const MessageBox({super.key, required this.message});

  bool get isCurUser => message.senderId == 'hehe';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: isCurUser
          ? Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kMediumPadding),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: kWhite,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  radius: 14,
                ),
                const SizedBox(width: kMediumPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kMediumPadding,
                        bottom: kSmallPadding,
                      ),
                      child: Text(
                        message.senderName,
                        style: const TextStyle(fontSize: 12, color: kDarkGrey),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(kMediumPadding),
                      decoration: const BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Hello world',
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
