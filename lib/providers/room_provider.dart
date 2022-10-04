import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/room.dart';

final defaultRoom = Room(
  id: '0',
  name: '',
  coverColor: 'blue',
  description: '',
  tags: [],
  maxPeople: 0,
  numPeople: 0,
  type: 'public',
  hostPhotoUrl: '',
);

class RoomNotifier extends ChangeNotifier {
  Room room = defaultRoom;

  void changeRoom(Room newRoom) {
    room = newRoom;
  }

  void exitRoom() {
    room = defaultRoom;
  }
}

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());
