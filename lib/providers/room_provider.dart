import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/room.dart';

class RoomNotifier extends ChangeNotifier {
  Room? room;

  void changeRoom(Room newRoom) {
    room = newRoom;
    notifyListeners();
  }

  void exitRoom() {
    room = null;
    notifyListeners();
  }
}

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());
