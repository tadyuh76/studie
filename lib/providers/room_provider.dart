import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/room.dart';

class RoomNotifier extends ChangeNotifier {
  Room? _room;

  Room get room => _room!;

  void changeRoom(Room newRoom) {
    _room = newRoom;
    notifyListeners();
  }

  void exitRoom() {
    _room = null;
    notifyListeners();
  }
}

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());
