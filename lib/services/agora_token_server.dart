import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class AgoraTokenServer {
  static Future<String> fetchToken(String channelName) async {
    String res = "";
    try {
      final url =
          "https://agora-token-service-production-7522.up.railway.app/rtc/$channelName/publisher/uid/00/?expiry=86400";
      final response = await http.get(Uri.parse(url));
      res = jsonDecode(response.body)["rtcToken"];
      print("rtcToken: $res");
    } catch (e) {
      debugPrint("error fetching token from server: $e");
    }
    return res;
  }

  static Future<String> updateUser() async {
    String res = "";

    return res;
  }
}
