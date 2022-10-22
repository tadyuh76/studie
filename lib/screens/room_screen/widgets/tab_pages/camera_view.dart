import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "0bad580c8d844946b43d9201ef4b4c22",
      channelName: "tadyuh76",
      username: "user",
      tempToken:
          "007eJxTYNCb07hpgdtB6c1zzJx6xKfbMN2vFLssLsB/84Zuxuq+6zcVGAySElNMLQySLVIsTEwsTcySTIxTLI0MDFPTTJJMko2MzH4FJ9cHMjJst3NgZWSAQBCfg6EkMaWyNMPcjIEBAF9tHzo=",
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  initAgora() async {
    try {
      await client.initialize();
    } catch (e) {
      debugPrint('error initializing agora: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AgoraVideoViewer(
          client: client,
          layoutType: Layout.grid,
        ),
        AgoraVideoButtons(
          client: client,
          enabledButtons: const [
            BuiltInButtons.switchCamera,
            BuiltInButtons.toggleCamera,
            BuiltInButtons.toggleMic,
          ],
        ),
      ],
    );
  }
}
