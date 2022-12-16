import 'package:flutter/services.dart';
import 'package:studie/constants/banner_colors.dart';

class Room {
  String _id = '';
  final String name;
  final String bannerColor;
  final String fileUrl;
  final String fileType;
  final String description;
  final String pomodoroType;
  final List<dynamic> tags;
  final int maxParticipants;
  final int curParticipants;
  final String type;
  final String hostPhotoUrl;
  final String hostUid;

  Room({
    required this.hostUid,
    required this.name,
    required this.bannerColor,
    required this.fileType,
    required this.fileUrl,
    required this.description,
    required this.pomodoroType,
    required this.tags,
    required this.maxParticipants,
    required this.curParticipants,
    required this.type,
    required this.hostPhotoUrl,
  });

  String get id => _id;
  Color get color => bannerColors[bannerColor]!;

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "name": name,
      "bannerColor": bannerColor,
      "fileUrl": fileUrl,
      "fileType": fileType,
      "description": description,
      "pomodoroType": pomodoroType,
      "tags": tags,
      "maxParticipants": maxParticipants,
      "curParticipants": curParticipants,
      "type": type,
      "hostUid": hostUid,
      "hostPhotoUrl": hostPhotoUrl,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    final room = Room(
      name: json['name'],
      bannerColor: json['bannerColor'],
      fileUrl: json['fileUrl'],
      fileType: json['fileType'],
      description: json['description'],
      pomodoroType: json['pomodoroType'],
      tags: json['tags'],
      maxParticipants: json['maxParticipants'],
      curParticipants: json['curParticipants'],
      type: json['type'],
      hostUid: json['hostUid'],
      hostPhotoUrl: json['hostPhotoUrl'],
    );
    room._id = json["id"];
    return room;
  }

  Room copyWith(String id) {
    _id = id;
    return this;
  }
}
