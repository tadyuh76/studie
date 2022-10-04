import 'package:flutter/services.dart';
import 'package:studie/constants/colors.dart';

class Room {
  final String id;
  final String name;
  final String coverColor;
  final String description;
  final List<String> tags;
  final int maxPeople;
  final int numPeople;
  final String type;
  final String hostPhotoUrl;

  Room({
    required this.id,
    required this.name,
    required this.coverColor,
    required this.description,
    required this.tags,
    required this.maxPeople,
    required this.numPeople,
    required this.type,
    required this.hostPhotoUrl,
  });

  Color get color => coverColor == 'blue' ? kPrimaryColor : kBlack;
}
