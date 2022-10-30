import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/room.dart';
import 'package:studie/services/db_methods.dart';

class RoomNotifier extends ChangeNotifier {
  Room? _room;

  Room? get room => _room;

  void changeRoom(Room newRoom) {
    _room = newRoom;
    notifyListeners();
  }

  void exitRoom(String roomId) {
    _room = null;
    DBMethods().leaveRoom(roomId);
    notifyListeners();
  }
}

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());
