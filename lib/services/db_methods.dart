import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:studie/constants/default_values.dart';
import 'package:studie/models/message.dart';
import 'package:studie/models/room.dart';
import 'package:studie/models/user.dart';
import 'package:studie/services/auth_methods.dart';

class DBMethods {
  final _db = FirebaseFirestore.instance;
  final _authMethods = AuthMethods();

  Stream<QuerySnapshot> getMessages(String roomId) {
    final snapshots = _db
        .collection("rooms")
        .doc(roomId)
        .collection('messages')
        .orderBy("createdAt", descending: true)
        .snapshots();

    return snapshots;
  }

  Future<void> sendMessage(String message, String roomId) async {
    try {
      final curUser = _authMethods.user;
      if (curUser == null) return;

      final messageObj = Message(
        id: '',
        senderId: curUser.uid,
        senderName: curUser.displayName ?? kDefaultName,
        senderPhotoURL: curUser.photoURL ?? "",
        text: message,
        createdAt: DateTime.now().toString(),
      );

      final docRef = await _db
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .add(messageObj.toJson());
      docRef.update({"id": docRef.id});
    } catch (e) {
      debugPrint('error sending message: $e');
    }
  }

  Future<void> addUserToDB(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "username": user.displayName ?? kDefaultName,
        "photoURL": user.photoURL ?? "",
        "email": user.email ?? "",
      });

      debugPrint('added user to db');
    } catch (e) {
      debugPrint('error adding user to db: $e');
    }
  }

  Stream<QuerySnapshot> getRooms() {
    return _db.collection('rooms').snapshots();
  }

  Future<bool> createRoom(Room room) async {
    bool created = true;
    try {
      final ref = await _db.collection('rooms').add(room.toJson());
      room.id = ref.id;
      ref.update({"id": ref.id});

      debugPrint('room created!');
    } catch (e) {
      debugPrint('error creating room: $e');
      created = false;
    }
    return created;
  }

  Future<String> joinRoom(String roomId) async {
    String result = "success";
    try {
      final user = UserModel.fromFirebaseUser(_authMethods.user!);
      final roomRef = _db.collection('rooms').doc(roomId);
      final roomSnapshot = await roomRef.get();
      final room = Room.fromJson(roomSnapshot.data() as Map<String, dynamic>);

      if (room.curParticipants >= room.maxParticipants) {
        return result = "Phòng học đã đầy!";
      }

      roomRef.collection('participants').doc(user.uid).set(user.toJson());
      roomRef.update({"curParticipants": FieldValue.increment(1)});

      debugPrint('joined room with id:  $roomId');
    } catch (e) {
      result = "Đã có lỗi xảy ra khi vào phòng học!";
      debugPrint('error joining room $e');
    }

    return result;
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      final user = _authMethods.user;
      final currentRoomIn = _db.collection('rooms').doc(roomId);
      currentRoomIn.collection('participants').doc(user!.uid).delete();

      final curParticipants =
          (await currentRoomIn.get()).data()!["curParticipants"];
      if (curParticipants == 1) {
        currentRoomIn.delete();
      } else {
        currentRoomIn.update({"curParticipants": FieldValue.increment(-1)});
      }

      debugPrint('left room !');
    } catch (e) {
      debugPrint('error leaving room: $e');
    }
  }
}
