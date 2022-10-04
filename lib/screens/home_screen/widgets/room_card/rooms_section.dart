import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/screens/home_screen/widgets/room_card/room_card.dart';

final List<Room> rooms = [
  Room(
    id: '1',
    name: 'Ôn tập Lí 12 Ôn tập Lí 12 Ôn tập Lí 12 Ôn tập Lí 12',
    coverColor: 'blue',
    description: 'Ai ôn lí chung hông?',
    tags: ['Lý 12', 'Học kỳ 1'],
    maxPeople: 16,
    numPeople: 12,
    type: 'public',
    hostPhotoUrl: 'assets/images/avatar.jpg',
  ),
  Room(
    id: '2',
    name: 'Ôn tập Hóa 12',
    coverColor: 'blue',
    description: 'Ai ôn hóa chung hông?',
    tags: ['Hóa 12', 'Học kỳ 1'],
    maxPeople: 7,
    numPeople: 5,
    type: 'public',
    hostPhotoUrl: 'assets/images/avatar.jpg',
  ),
  Room(
    id: '3',
    name: 'Ôn tập Toán 12',
    coverColor: 'blue',
    description: 'Ai ôn Toán chung hông?',
    tags: ['Toán 12', 'Học kỳ 1'],
    maxPeople: 4,
    numPeople: 4,
    type: 'public',
    hostPhotoUrl: 'assets/images/avatar.jpg',
  ),
  Room(
    id: '4',
    name: 'Đọc sách cùng mình hihi hihi hihi',
    coverColor: 'blue',
    description: 'Cùng đọc sách nào',
    tags: ['Đọc sách'],
    maxPeople: 5,
    numPeople: 2,
    type: 'public',
    hostPhotoUrl: 'assets/images/avatar.jpg',
  ),
];

Stream<List<Room>> getRooms() {
  return Stream.fromIterable([rooms]);
}

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
      stream: getRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return renderTitle();

              return RoomCard(room: snapshot.data![index - 1]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
