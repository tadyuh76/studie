import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/room_screen/room_screen.dart';

class EnterButton extends ConsumerWidget {
  final Room room;
  const EnterButton({super.key, required this.room});

  void onTap(BuildContext context, WidgetRef ref) {
    ref.read(roomProvider).changeRoom(room);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RoomScreen(room: room),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onTap(context, ref),
          child: const Center(
            child: Text(
              'Vào phòng học',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
