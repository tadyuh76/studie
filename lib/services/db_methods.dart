import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:studie/models/message.dart';
import 'package:studie/models/room.dart';
import 'package:studie/models/user.dart' as model;
import 'package:studie/services/auth_methods.dart';

class DBMethods {
  final _db = FirebaseFirestore.instance;

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
      final curUser = AuthMethods().user;
      final messageObj = Message(
        id: '',
        senderId: curUser.uid,
        senderName: curUser.displayName ?? "Ẩn danh",
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
      print('sent message');
    } catch (e) {
      print('error sending message: $e');
    }
  }

  Future<void> addUserToDB(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "username": user.displayName,
        "photoURL": user.photoURL,
        "email": user.email,
      });

      debugPrint('added user to db');
    } catch (e) {
      debugPrint('error adding user to db: $e');
    }
  }

  Stream<QuerySnapshot> getRooms() {
    return _db.collection('rooms').snapshots();
  }

  Future<void> createRoom(Room room) async {
    try {
      final ref = await _db.collection('rooms').add(room.toJson());
      room.id = ref.id;
      ref.update({"id": ref.id});

      debugPrint('room created!');
    } catch (e) {
      debugPrint('error creating room: $e');
    }
  }

  Future<void> joinRoom(
    String roomId,
  ) async {
    try {
      final user = model.UserModel.fromFirebaseUser(AuthMethods().user);
      final roomRef = _db.collection('rooms').doc(roomId);

      roomRef.collection('participants').doc(user.uid).set(user.toJson());
      roomRef.update({"curParticipants": FieldValue.increment(1)});

      debugPrint('joined room with id:  $roomId');
    } catch (e) {
      debugPrint('error joining room $e');
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      final user = AuthMethods().user;
      final currentRoomIn = _db.collection('rooms').doc(roomId);
      currentRoomIn.collection('participants').doc(user.uid).delete();

      final curParticipants =
          (await currentRoomIn.get()).data()!['curParticipants'];
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
