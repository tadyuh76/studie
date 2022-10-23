import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/models/user.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/utils/showSnackBar.dart';

class CameraViewPage extends ConsumerStatefulWidget {
  const CameraViewPage({super.key});

  @override
  ConsumerState<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends ConsumerState<CameraViewPage> {
  late UserModel _user;
  late AgoraClient _client;

  @override
  void initState() {
    super.initState();
    _user = ref.read(userProvider).user;
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "0bad580c8d844946b43d9201ef4b4c22",
        channelName: "tadyuh76",
        username: _user.username,
        tempToken:
            "007eJxTYNCb07hpgdtB6c1zzJx6xKfbMN2vFLssLsB/84Zuxuq+6zcVGAySElNMLQySLVIsTEwsTcySTIxTLI0MDFPTTJJMko2MzH4FJ9cHMjJst3NgZWSAQBCfg6EkMaWyNMPcjIEBAF9tHzo=",
      ),
    );
    initAgora();
  }

  initAgora() async {
    try {
      _client.initialize().whenComplete(() => print('initialized')).onError(
          (error, stackTrace) => showSnackBar(context, error.toString()));
    } catch (e) {
      debugPrint('error initializing agora: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _client.engine.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AgoraVideoViewer(
          client: _client,
          layoutType: Layout.grid,
        ),
        AgoraVideoButtons(
          client: _client,
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
