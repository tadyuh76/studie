import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/agora.dart';
import 'package:studie/models/user.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/utils/show_snack_bar.dart';

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
        appId: appId,
        tempToken: tempToken,
        channelName: "tadyuh76",
        username: _user.username,
      ),
    );
    // initAgora();
  }

  initAgora() async {
    try {
      await _client.initialize();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, "error initializing snackbar");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeAgora();
  }

  disposeAgora() async {
    try {
      await _client.engine.leaveChannel();
    } catch (e) {
      debugPrint("error leaving channel");
    }
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
    // return Container();
  }
}
