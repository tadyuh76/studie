import 'package:flutter/services.dart';
import 'package:studie/constants/banner_colors.dart';

class Room {
  String id = '';
  final String name;
  final String bannerColor;
  final String description;
  final List<dynamic> tags;
  final int maxParticipants;
  final int curParticipants;
  final String type;
  final String hostPhotoUrl;

  Room({
    this.id = '',
    required this.name,
    required this.bannerColor,
    required this.description,
    required this.tags,
    required this.maxParticipants,
    required this.curParticipants,
    required this.type,
    required this.hostPhotoUrl,
  });

  Color get color => bannerColors[bannerColor]!;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "bannerColor": bannerColor,
      "description": description,
      "tags": tags,
      "maxParticipants": maxParticipants,
      "curParticipants": curParticipants,
      "type": type,
      "hostPhotoUrl": hostPhotoUrl,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      bannerColor: json['bannerColor'],
      description: json['description'],
      tags: json['tags'],
      maxParticipants: json['maxParticipants'],
      curParticipants: json['curParticipants'],
      type: json['type'],
      hostPhotoUrl: json['hostPhotoUrl'],
    );
  }
}
