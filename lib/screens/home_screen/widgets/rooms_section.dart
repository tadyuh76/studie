import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/screens/home_screen/widgets/room_card/room_card.dart';
import 'package:studie/services/db_methods.dart';

class RoomsSection extends StatelessWidget {
  const RoomsSection({super.key});

  Widget renderTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Text(
        'Phòng học chung',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DBMethods().getRooms(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final rooms = snapshot.data!.docs.map((doc) {
            final roomJson = doc.data() as Map<String, dynamic>;
            final room = Room.fromJson(roomJson);
            return room;
          }).toList();

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rooms.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return renderTitle();

              return RoomCard(room: rooms[index - 1]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
