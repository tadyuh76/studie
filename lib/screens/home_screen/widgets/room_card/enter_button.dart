import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/room_screen/room_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/utils/show_snack_bar.dart';

class EnterButton extends ConsumerStatefulWidget {
  final Room room;
  const EnterButton({super.key, required this.room});

  @override
  ConsumerState<EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends ConsumerState<EnterButton> {
  bool joining = false;

  void onTap([mounted = true]) async {
    setState(() => joining = true);

    ref.read(roomProvider).changeRoom(widget.room);
    final result = await DBMethods().joinRoom(widget.room.id);
    if (mounted) {
      if (result != "success") {
        return showSnackBar(context, result);
      }

      setState(() => joining = false);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => RoomScreen(room: widget.room),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        child: IgnorePointer(
          ignoring: joining,
          child: InkWell(
            onTap: onTap,
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
      ),
    );
  }
}
